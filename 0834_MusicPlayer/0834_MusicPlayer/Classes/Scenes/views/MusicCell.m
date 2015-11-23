//
//  MusicCell.m
//  0834_MusicPlayer
//
//  Created by zyana on 15/11/4.
//  Copyright © 2015年 zyana. All rights reserved.
//

#import "MusicCell.h"

@interface MusicCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerLabel;

@end


@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMusicModel:(MusicModel *)musicModel{
    _musicModel = musicModel;
    _nameLabel.text = musicModel.name;
    _singerLabel.text = musicModel.singer;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl] placeholderImage:[UIImage imageNamed:@"2"]];
}





@end
