//
//  LZMSDKUtils.m
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import "LZMSDKUtils.h"

@interface LZMSDKUtils ()

@end

@implementation LZMSDKUtils

+ (instancetype)shareUtils {
    static LZMSDKUtils *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [LZMSDKUtils new];
    });
    return utils;
}

+ (UIImage *)getImage:(NSString *)imageName {
    NSString *assetBundle_path = [[NSBundle mainBundle] pathForResource:@"LZMWebViewSDK" ofType:@"bundle"];
    NSBundle *assetBundle = [NSBundle bundleWithPath:assetBundle_path];
    if (!assetBundle) {
//        NSLog(@"LZMWebViewSDK: Get_ERROR_Bundle");
        SDK_LOG(@"LZMWebViewSDK: Get_ERROR_Bundle");
        return nil;
    }
    NSString *image_path = [assetBundle pathForResource:imageName ofType:@"png"];
    if (!image_path) {
        SDK_LOG(@"Not exit: %@", imageName);
        return nil;
    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}

+ (UIFont *)getFontWithSize:(CGFloat)size weightType:(LZMFontWeightType)type {
    if (@available(iOS 8.2, *)){
        UIFontWeight font_type = UIFontWeightRegular;
        switch (type) {
            case LZMFontWeightType_Regular:
                font_type = UIFontWeightRegular;
                break;
            case LZMFontWeightType_Medium:
                font_type = UIFontWeightMedium;
                break;
            case LZMFontWeightType_Semibold:
                font_type = UIFontWeightSemibold;
                break;
            default:
                break;
        }
        return [UIFont systemFontOfSize:size weight:font_type];
    }
    switch (type) {
        case LZMFontWeightType_Regular:
            return [UIFont systemFontOfSize:size];
        case LZMFontWeightType_Medium:
        case LZMFontWeightType_Semibold:
        default:
            return [UIFont boldSystemFontOfSize:size];
    }
}

@end
