#import <YouTubeHeader/YTActionSheetAction.h>
#import <YouTubeHeader/YTElementsCellController.h>
#import <YouTubeHeader/YTIMenuRendererRoot.h>
#import <YouTubeHeader/YTIPanelContentRenderer.h>

// %hook YTShowSheetCommandHandler

// - (void)showSheetControllerForPanelContent:(YTIPanelContentRenderer *)panelContent sheetTheme:(int)sheetTheme sheetID:(id)sheetID entry:(id)entry fromView:(id)fromView sender:(id)sender {
//     HBLogDebug(@"Showing sheet with id: %@", sheetID);
//     HBLogDebug(@"Panel content: %@", panelContent);
//     HBLogDebug(@"Panel content array: %@", panelContent.legacyContentsListArray);
//     HBLogDebug(@"From view: %@", fromView);
//     HBLogDebug(@"Sender: %@", sender);
//     %orig;
// }

// %end

%hook YTSubtitledDialogActionButton

%new(v@:@)
- (void)setOnContentSizeDidChange:(id)arg1 {}

%end

%hook YTPanelContentBuilder

+ (NSMutableArray *)buildListOptionsViewForPanelContentRenderer:(YTIPanelContentRenderer *)panelContentRenderer parentResponder:(id)parentResponder {
    NSMutableArray *views = %orig;
    HBLogInfo(@"Building panel content with renderer: %@", panelContentRenderer);
    HBLogInfo(@"contents list: %@", panelContentRenderer.legacyContentsListArray);
    HBLogInfo(@"contents list count: %lu", panelContentRenderer.legacyContentsListArray.count);
    HBLogInfo(@"parentResponder: %@", parentResponder);
    if ([parentResponder isKindOfClass:%c(YTElementsCellController)] && [[[(YTElementsCellController *)parentResponder elementEntry] description] containsString:@"compactify_video_action_bar.eml"]) {
        YTIIcon *icon = [%c(YTIIcon) new];
        icon.iconType = YT_PICTURE_IN_PICTURE;
        YTActionSheetAction *action = [%c(YTActionSheetAction) actionWithTitle:@"Play in PiP" subtitle:nil iconImage:[icon iconImageWithColor:nil] handler:^(id arg1) {
            // Action
            HBLogDebug(@"YouPiP arg1: %@", arg1);
        }];
        [views addObject:action.button];
    }
    return views;
}

%end