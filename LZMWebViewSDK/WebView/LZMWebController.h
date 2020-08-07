//
//  LZMWebController.h
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/4.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//
//  by Sui.H 此webview不处理任何业务逻辑

#import <UIKit/UIKit.h>
//#import "LZMWebViewHelper.h"

NS_ASSUME_NONNULL_BEGIN
@class WKProcessPool;
@interface LZMWebController : UIViewController

/**
 *  导航栏按钮样式
 */
@property (nonatomic, assign) NSInteger navItemStyle;

/**
 *  是否显示下部分安全区域
 */
@property (nonatomic, assign) BOOL bottomShow;

/**
 *  是否为行政解忧
 */
@property (nonatomic, assign) BOOL isGrocery;
/**
 *  分享模型
 */
//@property (nonatomic, strong) CustShareModel *webShareModel; 

/**
 *  支付回调(支付处理经过webView不做逻辑，只做事件传递)
 */
@property (nonatomic, copy) void(^webViewPayBlock)(NSString *jsonStr, LZMWebController *controller);

/**
 *  缓存池
 */
@property (nonatomic, strong, readonly) WKProcessPool *pool;

/**
 *  请求网络资源
 *  @param currentURLString 当前url
 *  @param title 直接设置标题
 */
- (void)loadRequestURLStr:(NSString *)currentURLString naviTitle:(NSString *)title;

/**
 *  请求网络资源
 *  @param  request 请求的具体地址和设置
 */
- (void)loadRequestURL:(NSMutableURLRequest *)request;

/**
 *  请求网络资源带参数
 *  @param request  请求的具体地址和设置
 *  @param params   参数
 */
- (void)loadRequestURL:(NSMutableURLRequest *)request params:(NSDictionary *)params;

/**
 *  加载本地HTML页面
 *  @param htmlName 文件名称
 */
- (void)loadLocalHTMLWithFileName:(NSString *)htmlName;

/**
 *  重新加载
 */
- (void)reload_WebView;

/**
 *  重新加载网页,忽略缓存
 */
- (void)reload_FromOrigin;

/**
 *  清除所有缓存，保证每次加载的内容都是最新（不清除cookie，貌似暂时没有cookie)
 */
- (void)clearWebViewAllCache_Finish:(void(^)(BOOL finish,NSError *error))block;

@end

NS_ASSUME_NONNULL_END
