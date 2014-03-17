//
//  YGYPlayerToolBar.m
//  月光影音
//
//  Created by 吴琼 on 13-10-17.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import "YGYPlayerToolBar.h"

@implementation YGYPlayerToolBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//	[super drawRect:dirtyRect];
//	
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSaveGState(context);
//    
////    CGContextAddRect(context, dirtyRect);
//    
//    [NSColor colorWithDeviceRed:0.8 green:0.8 blue:0.8 alpha:0.6];
//    CGContextFillRect(context, dirtyRect);
//    
//    CGContextRestoreGState(context);
//}

@end
