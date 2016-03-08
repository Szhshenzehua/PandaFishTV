//
//  SIxPlepleModel.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "SIxPlepleModel.h"

@implementation SIxPlepleModel


+ (BOOL)propertyIsOptional:(NSString *)propertyName {

    return YES;
}

+ (NSMutableArray *)arrayOfDictionariesFromModels:(id)resond {
    
    
    NSArray *dataArray = resond[@"data"];
    
    
    NSMutableArray *resultarr = [NSMutableArray new];
    
    NSError * error;
    
    resultarr = [SIxPlepleModel arrayOfModelsFromDictionaries:dataArray error:&error];
    
    if (error) {
        
        NSLog(@"16个主播的信息%@",error);
    }
    
    return resultarr;
}


@end


@implementation Pictures

@end


