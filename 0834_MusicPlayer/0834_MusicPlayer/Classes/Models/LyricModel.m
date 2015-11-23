//
//  LyricModel.m
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/10.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

-(instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric{
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
}

@end
