//
//  LZMWebViewFunctionHandle.m
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/10/28.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import "LZMWebViewFunctionHandle.h"
//#import "LZMRequestManager.h"
//#import "LZMQRCodeScanController.h"
//#import "NSString+StringTool.h"

static NSString *const kJSCloseFunction        = @"goBackChuneng";
static NSString *const kJSRefreshTokenFunction = @"refreshToken";
static NSString *const kJSGetUserInfoFunction  = @"getUserInfo";
static NSString *const kJSRequestScanQrCodeFunction  = @"requestScanQrCode";

@interface LZMWebViewFunctionHandle ()
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) NSString *jsCallbackName;
@end

@implementation LZMWebViewFunctionHandle

#pragma mark - public
- (void)handleJsFunctionWitMethdName:(NSString *)functioNname withjsCallbackName:(NSString *)callbackName forObjDict:(NSDictionary *)objDict {
    NSLog(@"调用JS方法名为 %@ ",callbackName);

    _webView        = objDict[@"webView"];
    _controller     = objDict[@"ctr"];
    _jsCallbackName = !callbackName ? callbackName : @"";
    
    if ([functioNname isEqualToString:kJSRefreshTokenFunction]) {
        [self JsRefreshTokenFunction_handle];
    }
    else if ([functioNname isEqualToString:kJSGetUserInfoFunction]) {
        [self JsGetUserInfoFunction_handle];
    }
    else if ([functioNname isEqualToString:kJSRequestScanQrCodeFunction]) {
        [self JsScanQrCodeFunction_handle];
    }
    else if ([functioNname isEqualToString:kJSCloseFunction]) {
        [self back_Native];
    }
    else {
        return;
    }
}

#pragma mark - incident
/** 刷新token */
- (void)JsRefreshTokenFunction_handle {
    
}

/** 用户信息 */
- (void)JsGetUserInfoFunction_handle {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dict = @{@"appVersion" : appVersion,
                           @"nickname"   : @"lzmName",
                           @"phone"      : @"lzmUserPhone",
                           @"avatar"     : @"lzmAvatar"
                           };
    /** 字典转化成JSON字符串 */
    NSString *userInoStr = @"";
    
    userInoStr = [kLZMSDKUtils convertToJsonData:dict];
    [self evaluateJavaScriptForParameter:userInoStr];
}

/** 扫描二维码 */
- (void)JsScanQrCodeFunction_handle {
    NSLog(@"%s",__FUNCTION__);
}

/** 通用方法向JS传参 */
- (void)evaluateJavaScriptForParameter:(NSString *)parameter {
    NSString *jsParameter = [NSString stringWithFormat:@"%@('%@')",_jsCallbackName,parameter];
    [self.webView evaluateJavaScript:jsParameter completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"像JS传参成功 方法为%@",_jsCallbackName);
        }else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

/** 返回原生界面 */
- (void)back_Native {
    [self.controller.navigationController popViewControllerAnimated:true];
}

@end
