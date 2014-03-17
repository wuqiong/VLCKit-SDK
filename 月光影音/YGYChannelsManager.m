//
//  YGYChannelsManager.m
//  月光影音
//
//  Created by 吴琼 on 13-10-18.
//  Copyright (c) 2013年 长沙戴维营教育(http://www.diveinedu.cn). All rights reserved.
//

#import "YGYChannelsManager.h"
#import "YGYChannelsModel.h"
#import "AESCrypt.h"

@interface YGYChannelsManager () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *_channelsData;
}
@end

@implementation YGYChannelsManager

+ (instancetype)sharedManager
{
    static YGYChannelsManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YGYChannelsManager alloc] init];
    });
    
    return instance;
}

+ (void)loadChannelFromInernet
{
    YGYChannelsManager *manager = [YGYChannelsManager sharedManager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wuqiong.info:8088/channels.json"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:manager];
    [connection start];
}

- (NSArray *)channels
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"channels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //生成加密后的文件
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *encodeStr = [AESCrypt encrypt:str password:@"123456"];
//    
//    NSError *error;
//    [encodeStr writeToFile:@"/Users/cheetah/Desktop/channels.json" atomically:YES encoding:NSUTF8StringEncoding error: &error];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSString *)adHtml
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return content;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadChannelsNotification object:nil userInfo:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _channelsData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_channelsData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *encryptedString = [[NSString alloc] initWithData:_channelsData encoding:NSUTF8StringEncoding];
    NSString *decryptedString = [AESCrypt decrypt:encryptedString password:@"123456"];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if (!array) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadChannelsNotification object:nil userInfo:nil];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"channels"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadChannelsNotification object:nil userInfo:dict];
}
@end
