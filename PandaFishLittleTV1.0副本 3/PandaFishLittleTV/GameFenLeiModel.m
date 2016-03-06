//
//  GameFenLeiModel.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "GameFenLeiModel.h"

@implementation GameFenLeiModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {

    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    
    NSDictionary * dic = @{@"errno":@"err"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
    
}

@end


@implementation GameData
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


