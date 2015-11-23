//
//  MusicModel.m
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/4.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    // 异常处理
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    NSLog(@"error key : %@", key);
}

@end
