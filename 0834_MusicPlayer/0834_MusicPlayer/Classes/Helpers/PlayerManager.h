//
//  PlayerManager.h
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/5.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import <Foundation/Foundation.h>
// 代理
@protocol PlayerManagerDelegate <NSObject>
// 代理方法
// 当播放一首歌结束后，让代理去做的事情
- (void) playerDidPlayEnd;
// 播放中间一直在重复执行的一个方法
- (void) playerPlayingWithTime:(NSTimeInterval)time;

@end

@interface PlayerManager : NSObject

+ (instancetype) sharedManager;

// 给一个链接，让AVPlayer播放
- (void) playWithUrlString:(NSString *) urlStr;

// 播放
- (void) play;

// 暂停
- (void) pause;

// 是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
// 设置代理
@property (nonatomic, assign) id <PlayerManagerDelegate> delegate;

// 改变进度
- (void) seekToTime:(NSTimeInterval) time;

// 改变音量
- (void) changeToVolume:(CGFloat) volume;
// 用来访问AVPlayer的音量
- (CGFloat) volume;

@end
