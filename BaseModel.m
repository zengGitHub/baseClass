//
//  BaseModel.m
//  Steelmate
//
//  Created by 朗驰－曾家淇 on 16/8/21.
//  Copyright © 2016年 朗驰科技－曾家淇. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _modelArry = [[NSMutableArray alloc]init];

#if 1
        for (NSString * str in [self allPropertyNames]) {
            //在初始化时给所有属性赋值为@"",避免将空指针放入到数组中时程序崩溃
            [self setValue:@"" forKey:str];
            //思考：这样每个属性都赋值@"",会不会使内存增大

        }
#endif

    }
    return self;
}


- (void)setCellHeightWithCellData:(NSString *)cellData cellWidth:(CGFloat)cellWidth fontSize:(NSInteger)fontSize
{
    if (cellData==nil) {
        self.cellHeight = CGFLOAT_MIN;
        return;
    }
    NSDictionary *attributeDic =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [cellData boundingRectWithSize:CGSizeMake(cellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    self.cellHeight = ceilf(CGRectGetHeight(rect));
};

#pragma mark =========通过运行时获取model的所有属性==========

-(NSArray *)allPropertyNames{
    NSMutableArray * allName = [[NSMutableArray alloc]init];
    unsigned propertyCount = 0;
    objc_property_t * propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i<propertyCount; i++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [allName addObject:[NSString stringWithUTF8String:propertyName]];

    }
    free(propertys);
    return allName;
}


-(void)formattingTheModel
{
    //子类中实现
}

+(NSMutableArray *)getData
{
    return nil;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        [self setValue:@"空对象" forKey:key];
    }else if ([value isKindOfClass:[NSNumber class]])
    {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else
    {
        [super setValue:value forKey:key];
    }

}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //DLog(@"未定义的key值为：%@",key);
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

//************************************************************
        #pragma mark 注释:YYModel接口,对YYModel进行包装
//************************************************************

+(NSDictionary*)modelCustomPropertyMapper
{
    //子类中实现
    return nil;
}
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    //子类中实现
    return nil;
}
+ (NSArray *)modelPropertyBlacklist
{
    //子类中实现
    return nil;
}
+ (NSArray *)modelPropertyWhitelist
{
    //子类中实现
    return nil;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    //子类中实现
    return nil;
}
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    //子类中实现
    return nil;
}
@end
