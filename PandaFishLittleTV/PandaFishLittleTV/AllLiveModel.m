//
//  AllLiveModel.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "AllLiveModel.h"

@implementation AllLiveModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {


    return YES;

}
+ (JSONKeyMapper *)keyMapper {
    
    NSDictionary * dic = @{@"errno":@"err"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
    
}

@end

@implementation AllLiveData

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
    
}

@end

@implementation AllLiveItems
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
    
}

@end


@implementation AllLiveUserinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
    
}

@end


@implementation AllLivePictures
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
    
}

@end


