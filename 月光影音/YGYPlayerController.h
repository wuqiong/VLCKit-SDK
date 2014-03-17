//
//  YGYPlayerController.h
//  月光影音
//
//  Created by 吴琼 on 13-10-18.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface YGYPlayerController : NSObject

@property (weak) IBOutlet NSScrollView *channelsOutline;
@property (weak) IBOutlet NSSlider *volumeSlider;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSView *baseView;
@property (weak) IBOutlet WebView *adWebView;
@property (weak) IBOutlet NSOutlineView *sideOutlineView;
@property (weak) IBOutlet NSButton *playButton;

- (IBAction)didFullScreenClicked:(id)sender;
- (IBAction)didPlayPauseClicked:(id)sender;
- (IBAction)didVolumeChanged:(id)sender;
- (IBAction)minVolumeClicked:(id)sender;
- (IBAction)maxVolumeClicked:(id)sender;
- (IBAction)resolutionClicked:(id)sender;
- (IBAction)adClicked:(id)sender;
@end
