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

+ (void)makePhoneCall:(NSString *)phoneNum{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication  sharedApplication].delegate.window;
        NSMutableString * str ;
        if ([phoneNum hasPrefix:@"tel"]){
            str = [NSMutableString stringWithFormat:@"%@", phoneNum];
        }else{
            str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
        }
        UIWebView * callWebview = [[UIWebView alloc] init];
        callWebview.tag = 1314;
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [window addSubview:callWebview];
    });
}

@end
