//
//  PlayingViewController.m
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/5.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDataSource,UITableViewDelegate>

// 记录当前播放音乐的索引
@property (nonatomic, assign) NSInteger currentIndex;
// 记录当前正在播放的音乐
@property (nonatomic, retain) MusicModel *currentModel;

#pragma mark  - 控件

@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;

@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;

@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;

@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;

@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;

@property (strong, nonatomic) IBOutlet UISlider *slider4Time;

@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;

@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;

@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;




#pragma mrak  - 控件事件

- (IBAction)action4prev:(UIButton *)sender;


- (IBAction)action4PlayOrPause:(UIButton *)sender;

- (IBAction)action4Next:(UIButton *)sender;

- (IBAction)action4ChangeTime:(UISlider *)sender;

- (IBAction)action4ChangeVolume:(UISlider *)sender;

@end
static PlayingViewController *playingVC = nil;
static NSString *cellIdentifier = @"cell";

@implementation PlayingViewController

+ (instancetype) sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main sb
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 在main sb 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
}

- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 如果要播放的音乐和当前播放的音乐一样，就什么都不干
    if (_index == _currentIndex) {
        return;
    }else{
        // 如果和当前播放的音乐不一样，将当前播放的音乐更改为要播放的音乐
        _currentIndex = _index;
    }
    [self startPlay];
}

- (void) startPlay{
    
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    
    [self buildUI];
}

- (void) buildUI{
    self.lab4SingerName.text = self.currentModel.singer;
    self.lab4SongName.text = self.currentModel.name;
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    
    // 更改button(播放歌曲时暂停，然后点击下一首可以正常播放)
    [self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    
    // 改变进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue] / 1000;  // 除以1000换算成秒
    self.slider4Time.value = 0;
    
    // 更改旋转的角度,图片归位（更换歌曲后角度为0）
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    // 解析歌词
    [[LyricManager sharedManager] loadLyricWith:self.currentModel.lyric];
    // 刷新
    [self.tableView4Lyric reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentIndex = -1;
    
    // 设置自己为播放器的代理，帮播放器干一些事情
    [PlayerManager sharedManager].delegate = self;
    
    // 加圆角
    self.img4Pic.layer.masksToBounds = YES;
    self.img4Pic.layer.cornerRadius = 120;
    
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // 设置音量进度条
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 上一首
- (IBAction)action4prev:(UIButton *)sender {
    _currentIndex --;
    //    判断上一首是不是第一首
    if (_currentIndex == -1) {
        //        如果是第一首就播放最后一首
        _currentIndex = [DataManager sharedManager].allMusic.count - 1;
    }
    [self  startPlay];
}

// 暂停和播放事件
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放，就让播放器暂停，同时改变button的text，更改为播放
        [[PlayerManager sharedManager] pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        // 暂停状态：开始播放，并改变btn的text为暂停
        [[PlayerManager sharedManager] play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
    //TODO： 这里有个bug ，在暂停之后，点击下一首就不能再播放了！！！！！！
}

// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    // 在播放下一首时，先暂停，销毁timer
    [[PlayerManager sharedManager] pause];
    
    _currentIndex ++;
    // 判断是不是最后一首歌曲
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        // 如果是最后一首就播放第一首歌曲
        _currentIndex = 0;
    }
    [self startPlay];
}

// 改变播放的进度
- (IBAction)action4ChangeTime:(UISlider *)sender {
    UISlider *slider = sender;
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
}

// 改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    // 调用接口
    [[PlayerManager sharedManager] changeToVolume:1];
}

#pragma mark  - PlayerManagerDelegate
// 播放器播放结束了，开始播放下一首歌曲
- (void) playerDidPlayEnd{
    // 两种方法：
    // _currentIndex ++;
    // [self startPlay];
    [self action4Next:nil];
}

// 播放器每0.1秒会让代理（也就是这个页面）执行一下这个事件
- (void) playerPlayingWithTime:(NSTimeInterval)time{
//    NSLog(@"%f", time);
    self.slider4Time.value = time;
    
    // 播放的时间
    self.lab4PlayedTime.text = [self stringWithTime:time];
    
    // 剩余时间
    NSTimeInterval time2 = [self.currentModel.duration integerValue] / 1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    
    // 每0.1秒选择1度（图片旋转）
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI / 180);
    
    // 根据当前播放时间获取到应该播放哪句歌词
    NSInteger index = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView 选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

// 根据时间获取到字符串
- (NSString *) stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger seconde = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld", minutes, seconde];
}

#pragma mark  - 重写getter方法
// 确保当前播放的音乐是最新的
- (MusicModel *) currentModel{
    MusicModel *model = [[DataManager sharedManager] musicModelWithIndex:_currentIndex];
    return model;
}

#pragma mark   - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].allLyric.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // 取到对应的cell
    LyricModel *lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    // 设置歌词
    cell.textLabel.text = lyric.lyricContext;
    // 歌词居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}





@end
