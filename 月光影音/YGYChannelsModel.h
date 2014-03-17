//
//  YGYChannelsModel.h
//  月光影音
//
//  Created by 吴琼 on 13-10-18.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGYChannelsModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong, readonly) NSMutableArray *subChannels;    //子频道
@property (nonatomic, strong, readonly) NSMutableArray *resolutions;    //清晰度

@end
