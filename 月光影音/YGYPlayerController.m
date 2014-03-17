//
//  YGYPlayerController.m
//  月光影音
//
//  Created by 吴琼 on 13-10-18.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import "YGYPlayerController.h"
#import "YGYPlayerToolBar.h"

#import "YGYChannelsManager.h"

#import "VLCConstants.h"

#import <VLCKit/VLCKit.h>
//#import "AnalyticsHelper.h"

@interface YGYPlayerController () <NSOutlineViewDataSource, NSOutlineViewDelegate, VLCMediaPlayerDelegate>
{
    VLCVideoView *_videoView;
    VLCMediaPlayer *_mediaPlayer;
    NSRect _originalRect;
    
    NSPanel *_controlsPanel;
    
    NSArray *_channelsArray;
}

@property (weak) IBOutlet YGYPlayerToolBar *playerToolBar;
@property (weak) IBOutlet NSView *mediaView;
@end

@implementation YGYPlayerController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelLoaded:) name:kLoadChannelsNotification object:nil];
    
//    [_controlsPanel setFloatingPanel:YES];
//    [_controlsPanel setMovableByWindowBackground:YES];
    
    //老方法，从本地读取频道列表
//    _channelsArray = [NSArray arrayWithArray:[[YGYChannelsManager sharedManager] channels]];
    [YGYChannelsManager loadChannelFromInernet];
    
//    [_mediaView setWantsLayer:YES];
    
    _videoView = [[VLCVideoView alloc] initWithFrame:NSMakeRect(0, 0, self.mediaView.frame.size.width, self.mediaView.frame.size.height)];
    
    [_videoView setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
    
    [self.mediaView addSubview:_videoView];
    _mediaPlayer = [[VLCMediaPlayer alloc] initWithVideoView:_videoView];
    _mediaPlayer.delegate = self;
    
//    NSString *content = [[YGYChannelsManager sharedManager] adHtml];
//    NSLog(@"%@", content);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diveinedu.cn/ad_alimama.html"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diveinedu.cn/ad_amazon.html"]];
    [[_adWebView mainFrame] loadRequest:request];
    
//    [_baseView setWantsLayer:YES];
//    [_playerToolBar setWantsLayer:YES];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    _mediaPlayer = [[VLCMediaPlayer alloc] initWithOptions:@[[NSString stringWithFormat:@"--%@=%@", kVLCSettingSubtitlesFont, [defaults objectForKey:kVLCSettingSubtitlesFont]], [NSString stringWithFormat:@"--%@=%@", kVLCSettingSubtitlesFontColor, [defaults objectForKey:kVLCSettingSubtitlesFontColor]], [NSString stringWithFormat:@"--%@=%@", kVLCSettingSubtitlesFontSize, [defaults objectForKey:kVLCSettingSubtitlesFontSize]], [NSString stringWithFormat:@"--%@=%@", kVLCSettingDeinterlace, [defaults objectForKey:kVLCSettingDeinterlace]]]];
//    
//
//    [_mediaPlayer setDrawable:_mediaView];
//    _mediaPlayer.scaleFactor = 0;
    
//    NSLog(@"%@", _mediaView.layer);
//    [_mediaPlayer setDrawable:_mediaView.layer];
    
//    _mediaPlayer = [[VLCMediaPlayer alloc] initWithVideoView:_mediaView];
//    [_mediaPlayer setDrawable:_mediaView];
    
    NSLog(@"%@", _baseView.subviews);
    NSLog(@"%@", _baseView.layer.sublayers);
    
    _originalRect = _mediaView.frame;
    
//    [self playChannelURL:[[_channelsArray objectAtIndex:0] objectForKey:@"url"]];
//    [self logWithChannel:[[_channelsArray objectAtIndex:0] objectForKey:@"name"]];
}

- (void)channelLoaded:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo) {
        _channelsArray = [userInfo objectForKey:@"channels"];
        [_sideOutlineView reloadData];
        
        if (_channelsArray && [_channelsArray count]) {
            [self playChannelURL:[[_channelsArray objectAtIndex:0] objectForKey:@"url"]];
        }
    }
}

- (void)logWithChannel:(NSString *)channel
{
//    [AnalyticsHelper.sharedInstance recordCachedEventWithCategory:channel
//                                                           action:@"切换频道"
//                                                            label:@"播放电视"
//                                                            value:@1];
}

- (void)playChannelURL:(NSString *)url
{
////    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://202.102.254.156/cdn.baidupcs.com/file/646a6c3ce1a856843210f5c06a488e99?xcode=ff7c0eb62618027a0bfb1c356ceb4c61c25b9688cb46bf9f&fid=3792016278-250528-3328537339&time=1382839038&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-8Lr%2BtAj6gO%2Bmb7cKY0IRAfo51AY%3D&to=cb&fm=B,B,U,nc&expires=8h&rt=sh&r=125703263&logid=1225676458&sh=1&wshc_tag=0&wsiphost=ipdbm "]];
//    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL fileURLWithPath:@"/Users/cheetah/Desktop/Cocoa开发/Cocoa Programming L6 - Size Attributes - YouTube [720p].mp4"]];
    
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:url]];
    [_mediaPlayer setMedia:media];
    [_mediaPlayer play];
    
    [_playerToolBar setNeedsDisplay:YES];
}

- (void)hiddenChannels:(BOOL)bHidden
{
    if (bHidden) {
        _channelsOutline.frame = NSMakeRect(-_channelsOutline.frame.size.width, _channelsOutline.frame.origin.y, _channelsOutline.frame.size.width, _channelsOutline.frame.size.height);
    } else {
        _channelsOutline.frame = NSMakeRect(0, _channelsOutline.frame.origin.y, _channelsOutline.frame.size.width, _channelsOutline.frame.size.height);
    }
}

- (IBAction)didDragButtonClicked:(id)sender {
    
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_channelsArray count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [_channelsArray objectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSArray class]]) {
        return YES;
    }
    
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[NSArray class]]) {
        return @"频道列表";
    }
    
    return [item objectForKey:@"name"];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    [self playChannelURL:[item objectForKey:@"url"]];
    [self logWithChannel:[item objectForKey:@"name"]];
    
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

#pragma mark - WebView
- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation
                                                          request:(NSURLRequest *)request
                                                            frame:(WebFrame *)frame
                                                 decisionListener:(id <WebPolicyDecisionListener>)listener
{
    if ([actionInformation objectForKey:WebActionElementKey]) {
        [listener ignore];
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    }
    else {
        [listener use];
    }
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
   newFrameName:(NSString *)frameName
decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if ([actionInformation objectForKey:WebActionElementKey]) {
        [listener ignore];
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    }
    else {
        [listener use];
    }
}

#pragma mark VCLMediaPlayer Delegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    //NSLog(@"%@", aNotification.userInfo);
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    //NSLog(@"%@", aNotification.userInfo);
    if (_mediaPlayer.isPlaying) {
        [_mediaView setHidden:NO];
        [_playButton setImage:[NSImage imageNamed:@"pause"]];
    }
    else {
        [_mediaView setHidden:YES];
        [_playButton setImage:[NSImage imageNamed:@"play"]];
    }
}

- (IBAction)didFullScreenClicked:(id)sender {
    
    if ([_baseView isInFullScreenMode]) {
        [_controlsPanel setHidesOnDeactivate:YES];
        
//        [_baseView exitFullScreenModeWithOptions:nil];
        
        [self hiddenChannels:NO];
        _mediaView.frame = _originalRect;
    } else {
//        [_baseView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
        
        [self hiddenChannels:YES];
        
//        [_mediaPlayer stop];
        _mediaView.frame = _baseView.bounds;
        
        [_controlsPanel makeKeyAndOrderFront:nil];
        
//        [_mediaPlayer play];
        
        NSLog(@"%@", NSStringFromRect(_baseView.bounds));
    }
}

- (IBAction)didPlayPauseClicked:(id)sender {
    [_mediaPlayer pause];
}

- (IBAction)didVolumeChanged:(id)sender {
    _mediaPlayer.audio.volume = [_volumeSlider integerValue];
}

- (IBAction)minVolumeClicked:(id)sender {
    if (_mediaPlayer.audio.volume <= 0) {
        return;
    }
    
    [_volumeSlider setIntegerValue:_mediaPlayer.audio.volume];
}

- (IBAction)maxVolumeClicked:(id)sender {
    if (_mediaPlayer.audio.volume >= 200) {
        return;
    }
    
    [_volumeSlider setIntegerValue:_mediaPlayer.audio.volume];
}

- (IBAction)resolutionClicked:(id)sender {
}

- (IBAction)adClicked:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.diveinedu.cn"]];
}
@end
