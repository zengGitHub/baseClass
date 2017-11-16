//
//  BaseModel.h
//  Steelmate
//
//  Created by 朗驰－曾家淇 on 16/8/21.
//  Copyright © 2016年 朗驰科技－曾家淇. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "YYModel.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface BaseModel : NSObject


@property (nonatomic,assign) CGFloat cellHeight;
@property (strong, nonatomic) NSMutableArray * modelArry;

+(NSMutableArray *)getData;
-(void)formattingTheModel;
-(NSArray *)allPropertyNames;

-(void)setCellHeightWithCellData:(NSString *)cellData cellWidth:(CGFloat)cellWidth fontSize:(NSInteger)fontSize; //andFontSize:(NSInteger)fontSize;



#if 0
//************************************************************
         #pragma mark 注释:YYModel接口,对YYModel进行包装
//************************************************************
/**
 *  返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)modelCustomPropertyMapper;
/**
 *  返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)modelContainerPropertyGenericClass;
/**
 *  黑名单,如果实现了该方法，则处理过程中会忽略该列表内的所有属性
 *
 *  @return NSArray
 */
+ (NSArray *)modelPropertyBlacklist;
/**
 *  白名单,如果实现了该方法，则处理过程中不会处理该列表外的属性。
 *
 *  @return NSArray
 */
+ (NSArray *)modelPropertyWhitelist;
/**
 *  当 JSON 转为 Model 完成后，该方法会被调用.
 *  你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略.
 *  你也可以在这里做一些自动转换不能完成的工作.
 *  @param dic 网络数据的dic
 *
 *  @return BOOL
 */
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;
/**
 *   当 Model 转为 JSON 完成后，该方法会被调用.
 *  你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略.
 *  你也可以在这里做一些自动转换不能完成的工作.
 *  @param dic 网络数据的dic
 *
 *  @return BOOL
 */
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;

#endif

@end
