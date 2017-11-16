//
//  AddAdviseCell.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/9.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "SelectPhotoCell.h"

@implementation SelectPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureImageView.layer.masksToBounds = YES;
    self.pictureImageView.userInteractionEnabled = YES;
}

- (void)initCellWithModel:(id)data
{
    if ([data isKindOfClass:[ZLPhotoAssets class]]) {
        _pictureImageView.image = [data thumbImage];
    }else if ([data isKindOfClass:[UIImage class]]){
        _pictureImageView.image = data;
    }
}

- (void)tapGesAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了图片");
}

@end
