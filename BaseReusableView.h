//
//  BaseReusableView.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/17.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
/**
 *  view的回调Block
 *
 *  @param view 点击的View
 */
typedef void(^ReturnBlock)(id view);
//typedef void(^PayManagerRespBlock)(NSInteger respCode,NSString *respMessage);
@interface BaseReusableView : UICollectionReusableView

@property (nonatomic,copy) ReturnBlock clickBlock;
//一定要是weak否则可能会造成Retain Cycle循环引用导致内存泄露
@property (nonatomic,weak) BaseVC * controller;

- (void)initSubViewWithData:(id)data;


@end
