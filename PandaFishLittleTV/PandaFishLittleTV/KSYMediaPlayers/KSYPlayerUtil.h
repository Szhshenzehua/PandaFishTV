//
//  KSYPlayerUtil.h
//  KSYMediaPlayer
//
//  Created by JackWong on 15/5/8.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSYPlayerUtil : NSObject
+ (NSString *)URLEncodedString:(NSString *)str;
+ (NSString *)ksyPlaySignatureWithsecretKey:(NSString *)secretKey
                                  httpVerb:(NSString *)httpVerb
                                    expire:(NSString *)expire
                                     nonce:(NSString *)nonce;

+ (NSUInteger)getTimeIntervalSinceNow:(NSTimeInterval)timeInterval;
@end
