//
//  YGYCustomView.m
//  月光影音
//
//  Created by 吴琼 on 13-10-22.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import "YGYCustomView.h"

@implementation YGYCustomView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    NSRect image_rect;
    NSImage *img = [NSImage imageNamed:@"play"];
    image_rect.size = [img size];
    image_rect.origin.x = 0;
    image_rect.origin.y = 0;

    [img drawInRect:image_rect fromRect:image_rect operation:NSCompositeSourceOver fraction:1];
}

@end
