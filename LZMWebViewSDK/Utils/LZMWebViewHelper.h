//
//  LZMWebViewHelper.h
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/4.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//
//  by Sui.H 用于LZMWebController功能扩展,业务处理

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const webCallObjc_ShowImage;

@interface LZMWebViewHelper : NSObject

/** Cookie 预留 */
+ (NSURL *)generateURL:(NSString *)baseURL params:(NSDictionary *)params;
+ (NSString *)phpCookieStringWithDomain:(NSString *)domain;
+ (NSMutableArray *)sharedHTTPCookieStorage;

/** ios11 同步cookies */
+ (void)syncCookiesToWKHTTPCookieStore:(WKHTTPCookieStore *)cookieStroe API_AVAILABLE(macosx(10.13), ios(11.0));

/** 清除webview缓存 */
+ (void)clearWebAllCacheFinish:(void (^)(BOOL, NSError *))block;


/// 事件处理, 返回处理是否成功
+ (BOOL)underRequestUrlHandleEvent:(NSURL *)url controller:(UIViewController *)vc;
+ (void)handleJumpId:(NSString *)jumpId jumpType:(NSInteger)jumpType jumpUrl:(NSString *)jumpUrl title:(NSString *)title controller:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
