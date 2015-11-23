//
//  DataManager.h
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/4.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void (^upDataUI) ();

@interface DataManager : NSObject

@property (nonatomic, copy) upDataUI myUpDataUI;
@property (nonatomic, retain) NSArray *allMusic;

/**
 *  单例方法
 *
 *  @return 单例
 */
+ (DataManager *) sharedManager;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (MusicModel *) musicModelWithIndex:(NSInteger) index;

@end
