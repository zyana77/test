//
//  PlayingViewController.h
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/5.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

+ (instancetype) sharedPlayingPVC;

// 要播放第几首歌曲
@property (nonatomic, assign) NSInteger index;

@end
