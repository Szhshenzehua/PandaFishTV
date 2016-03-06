//
//  DrmRelativeModel.h
//  KSYMediaPlayer
//
//  Created by JackWong on 15/4/21.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrmRelativeModel : NSObject

@property (strong, nonatomic) NSString *kscDrmHost;
@property (strong, nonatomic) NSString *customName;
@property (strong, nonatomic) NSString *drmMethod;
@property (strong, nonatomic) NSString *accessKeyId;
@property (strong, nonatomic) NSString *expire;
@property (strong, nonatomic) NSString *nonce;
@property (strong, nonatomic) NSString *cekVersion;
@property (assign, nonatomic) int visible;

@end
