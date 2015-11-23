//
//  LyricManager.h
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/10.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject
// 对外的歌词数组
@property (nonatomic, retain) NSArray *allLyric;

+ (instancetype) sharedManager;

- (void) loadLyricWith:(NSString *) lyricStr;

/**
 *  根据播放时间获取到该播放的歌词的索引
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger) indexWith:(NSTimeInterval) time;



@end
