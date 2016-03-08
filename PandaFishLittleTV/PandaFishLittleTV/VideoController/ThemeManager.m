//
//  ThemeManager.m
//  KSYVideoDemo
//
//  Created by Blues on 15/5/25.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define KSYBLUE     [UIColor colorWithRed:11 / 255.0  green:88 / 255.0  blue:208 / 255.0 alpha:1]
#define KSYGREEN    [UIColor colorWithRed:140 / 255.0 green:212 / 255.0 blue:0.0         alpha:1]
#define KSYORANGE   [UIColor colorWithRed:1.0         green:112 / 255.0 blue:11  / 255.0 alpha:1]
#define KSYPINK     [UIColor colorWithRed:1.0         green:100 / 255.0 blue:100 / 255.0 alpha:1]
#define KSYRED      [UIColor colorWithRed:162 / 255.0 green:0.0         blue:13  / 255.0 alpha:1]

#import "ThemeManager.h"

@interface ThemeManager ()

@property (nonatomic, strong) NSString *strThemeName;
@property (nonatomic, strong) NSString *strThemePath;
@property (nonatomic, strong) NSString *strResourcePath;
@property (nonatomic, strong) UIColor  *themeColor;

@end

@implementation ThemeManager

+ (ThemeManager *)sharedInstance {
    static ThemeManager *shareObj = nil;
    static dispatch_once_t onceObj;
    dispatch_once(&onceObj, ^{
        shareObj = [[self alloc] init];
    });
    return shareObj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _strResourcePath = [[NSBundle mainBundle] resourcePath];
    }
    return self;
}

- (NSString *)changeTheme:(NSString *)themeName {
    if (!themeName || [themeName isEqualToString:@""]) {
        return nil;
    }
    
    // **** 主题包是否存在
    NSString *strPath = [_strResourcePath stringByAppendingPathComponent:themeName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:strPath] == YES) {
        _strThemeName = themeName;
        _strThemePath = strPath;
        _themeColor = [self themeColorWithThemeName:themeName];
        return strPath;
    }
    else {
        NSString *strBundlePath = [[NSBundle mainBundle] resourcePath];
        strPath = [strBundlePath stringByAppendingPathComponent:@"blue"];
        _strThemeName = @"blue";
        _strThemePath = strPath;
        _themeColor = KSYBLUE;
//        NSLog(@"########## 主题包不存在，默认主题为蓝色！##########");
        return nil;
    }
}

- (UIImage *)imageInCurThemeWithName:(NSString *)strName {
    
    // **** 图片文件是否存在
    if (IS_IPHONE_6P) {
        strName = [strName stringByAppendingString:@"@3x.png"];
    }
    else {
        strName = [strName stringByAppendingString:@"@2x.png"];
    }
    NSString *strImgPath = [_strThemePath stringByAppendingPathComponent:strName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:strImgPath] == YES) {
        UIImage *image = [UIImage imageWithContentsOfFile:strImgPath];
        return image;
    }
    return nil;
}

- (void)setStrResourcePath:(NSString *)strResourcePath {
    if (!strResourcePath || [strResourcePath isEqualToString:@""]) {
        return;
    }
    
    // **** 路径是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:strResourcePath] == YES) {
        _strResourcePath = strResourcePath;
    }
    else {
//        NSLog(@"######### 资源路径不存在！##########");
    }
}

- (UIColor *)themeColor {
    return _themeColor;
}

- (UIColor *)themeColorWithThemeName:(NSString *)themeName {
    if ([themeName isEqualToString:@"blue"] == YES) {
        return KSYBLUE;
    }
    if ([themeName isEqualToString:@"green"] == YES) {
        return KSYGREEN;
    }
    if ([themeName isEqualToString:@"orange"] == YES) {
        return KSYORANGE;
    }
    if ([themeName isEqualToString:@"pink"] == YES) {
        return KSYPINK;
    }
    if ([themeName isEqualToString:@"red"] == YES) {
        return KSYRED;
    }
    return KSYBLUE;
}

@end
