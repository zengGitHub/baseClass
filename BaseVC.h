//
//  BaseVC.h
//  ChargerManager
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController


@property (nonatomic,strong) NSMutableDictionary * pamaras;
@property (nonatomic,strong) NSString * url;


- (void)initSubView;
- (void)loadNetDataAnimated:(BOOL)animated;

- (void)showbgImageView;
- (void)showNullImageViewInView:(UIView *)view;
- (void)hideNullImageViewFromView:(UIView *)view;

-(void)pushWebControllerWithTitle:(NSString *)title url:(NSString *)url;
- (void)readPhotoWithArray:(NSArray *)sourceArray andIndex:(NSInteger)index;

@end
