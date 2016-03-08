//
//  SubGameModel.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "SubGameModel.h"

@implementation SubGameModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {

    return YES;

}


+ (JSONKeyMapper *)keyMapper {
    
    NSDictionary * dic = @{@"errno":@"err"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
    
}

@end
@implementation subGameData
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}


@end


@implementation subGameType
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


@implementation subGameItems
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


@implementation subGameClassification
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


@implementation subGameUserinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


@implementation subGamePictures
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


