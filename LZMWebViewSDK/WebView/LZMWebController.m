//
//  LZMWebController.m
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/4.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import "LZMWebController.h"
#import "WkScriptMessageDelegate.h"
#import "LZMWebViewNavView.h"
#import "LZMWebViewHelper.h"
//#import "LZMWebViewFunctionHandle.h"
//#import "LZMWebPayService.h"

static NSString *const kJSPayFunction          = @"pay";
static NSString *const kJSCloseFunction        = @"goBackChuneng";
static NSString *const kJSRefreshTokenFunction = @"refreshToken";
static NSString *const kJSGetUserInfoFunction  = @"getUserInfo";
static NSString *const kJSRequestScanQrCodeFunction  = @"requestScanQrCode";
static NSInteger const REQ_Timeout      = 15;
static BOOL isReload_webView = NO;

@interface LZMWebController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
/** wkweb相关 */
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *config;
/** 标题 **/
@property (nonatomic, copy) NSString *naviTitle;
/** 当前的url **/
@property (nonatomic, copy) NSString *currentURLString;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *webviewProgressView;
/** 导航条 */
@property (nonatomic, strong) LZMWebViewNavView *navView;
@end

@implementation LZMWebController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createSubView];

    [self webview_LoadRequest];

    [self gestureHandle];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self pauseHtmlMusic];
}

- (void)createSubView {
    self.view.backgroundColor = LZMColor_C10;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.webviewProgressView];

//    [self setAutoAjustOfScrollView:self.webView.scrollView isNeedAuto:false];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.top.mas_equalTo(SafeAreaTopHeight);
        make.bottom.mas_equalTo(self.view).offset(self.bottomShow ? -SafeAreaBottomHeight : 0.0);
    }];

    [_webviewProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(0.1);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1.5f);
    }];
}

- (void)dealloc {
    if (_webView) {
        if(self.webView.scrollView.delegate)self.webView.scrollView.delegate = nil;
        if(self.webView.navigationDelegate) self.webView.navigationDelegate = nil;
        if(self.webView.UIDelegate) self.webView.UIDelegate = nil;
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self pauseHtmlMusic];
        [self.webView.configuration.userContentController removeAllUserScripts];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kJSPayFunction];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kJSCloseFunction];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
/** 重新加载 */
- (void)reload_WebView {
    isReload_webView = true;
    [self.webView reload];
}

/** 重新加载网页,忽略缓存 */
- (void)reload_FromOrigin {
    isReload_webView = true;
    [self.webView reloadFromOrigin];
}

- (void)setBottomShow:(BOOL)bottomShow {
    _bottomShow = bottomShow;
}

- (void)setNavItemStyle:(NSInteger)navItemStyle {
    _navItemStyle = navItemStyle;
}

- (void)loadRequestURL:(NSMutableURLRequest *)request {
     NSString *Domain = request.URL.host;
    _webView = _webView ? _webView : self.webView;
    /** 插入cookies  */
//    if (Domain)[self.config.userContentController addUserScript:[self searchCookieForUserScriptWithDomain:Domain]];
//    if (Domain)[request setValue:[LZMWebViewHelper phpCookieStringWithDomain:Domain] forHTTPHeaderField:@"Cookie"];
    /** 重置空白界面 */
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [_webView loadRequest:request];
}

- (void)loadLocalHTMLWithFileName:(NSString *)htmlName {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL    *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}

- (void)loadRequestURL:(NSMutableURLRequest *)request params:(NSDictionary *)params {
    NSURL *URLString = [LZMWebViewHelper generateURL:request.URL.absoluteString params:params];
    request.URL = URLString;
    [self loadRequestURL:request];
}

- (void)loadRequestURLStr:(NSString *)currentURLString naviTitle:(NSString *)title {
    self.currentURLString = @"";
    self.currentURLString = currentURLString;
    NSString *encodeUrl = [self.currentURLString URLEncodedString];
    self.currentURLString = encodeUrl;
    self.naviTitle = title;

    /** test url */
    //self.currentURLString = @"https://test4dev.oss-cn-shenzhen.aliyuncs.com/webview/index.html";
}

- (void)clearWebViewAllCache_Finish:(void (^)(BOOL, NSError * _Nonnull))block {
    [LZMWebViewHelper clearWebAllCacheFinish:block];
}

#pragma mark - http
- (void)webview_LoadRequest {
    if (!self.currentURLString) {return;}
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentURLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:REQ_Timeout];
    [_webView loadRequest:request];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.webviewProgressView.hidden = YES;
            [self.webviewProgressView setProgress:0 animated:NO];
        }else {
            self.webviewProgressView.hidden = NO;
            [self.webviewProgressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - incident
- (void)clickNavBack {
    self.webView.canGoBack ? [self.webView goBack] : [self popView_Controller];
}

- (void)clickNavBackTagType:(LZMWebViewNavViewTag)type {
    switch (type) {
        case LZMWebViewNavView_back:
             self.webView.canGoBack ? [self.webView goBack] : [self popView_Controller];
            break;
        case LZMWebViewNavView_close:
            [self popView_Controller];
            break;
        case LZMWebViewNavView_phone:
            [LZMSDKUtils makePhoneCall:@"10086"];
            break;
        case LZMWebViewNavView_share:{
//            CustShareView *shareView = [CustShareView new];
//            if (_isGrocery&&LZMStrIsNotEmpty(self.currentURLString)) {
//               self.webShareModel.sharedUrl = [NSString stringWithFormat:@"%@?isinside=1",self.currentURLString];
//            }
//            shareView.shareModel = self.webShareModel;
//            [shareView showShare:self];
        }
            break;
        default:
            break;
    }
}

- (void)popView_Controller {
     [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - private
//- (WKUserScript *)searchCookieForUserScriptWithDomain:(NSString *)domain {
//    NSString *cookie = [self jsCookieStringWithDomain:domain];
//    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    return cookieScript;
//}

- (NSString *)jsCookieStringWithDomain:(NSString *)domain {
    @autoreleasepool {
        NSMutableString *cookieSting = [NSMutableString string];
        NSArray *cookieArr = [LZMWebViewHelper sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArr) {
            if ([cookie.domain containsString:domain]) {
                [cookieSting appendString:[NSString stringWithFormat:@"document.cookie = '%@=%@';",cookie.name,cookie.value]];
            }
        }
        return cookieSting;
    }
}

/** 关闭Html声音 */
- (void)pauseHtmlMusic{
    self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    NSString *jsAudio = @"var vids = document.getElementsByTagName('audio'); for( var i = 0; i < vids.length; i++ ){vids.item(i).pause()}";
    [self.webView evaluateJavaScript:jsAudio completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
}

/** 手势处理 */
- (void)gestureHandle {
    if (@available(iOS 11.0, *)){
        for (UIView* subview in self.webView.scrollView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"WKContentView")]){
                for (UIGestureRecognizer* longPress in subview.gestureRecognizers) {
                    if ([longPress isKindOfClass:UILongPressGestureRecognizer.class]) {
                        [subview removeGestureRecognizer:longPress];
                    }
                }
            }
        }
    }else{
        for (UIView* subview in self.webView.scrollView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"WKContentViewMinusAccessoryView")]){
                for (UIGestureRecognizer* longPress in subview.gestureRecognizers) {
                    if ([longPress isKindOfClass:UILongPressGestureRecognizer.class]) {
                        [subview removeGestureRecognizer:longPress];
                    }
                }
            }
        }
    }
}

//#pragma mark - delegate
///** 页面加载完成 */
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    /** 不执行前段界面弹出列表的JS代码 */
//    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
//    if ([webView.URL.absoluteString.lowercaseString isEqualToString:@"about:blank"]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [webView.backForwardList performSelector:NSSelectorFromString(@"_removeAllItems")];
//#pragma clang diagnostic pop
//    }
//
//    NSString *htmlTitle = @"document.title";
//    [webView evaluateJavaScript:htmlTitle completionHandler:^(NSString * _Nullable title, NSError * _Nullable error) {
//        if (!webView.canGoBack) {
//            self.navView.titleStr = LZMStrIsNotEmpty(self.naviTitle) ? self.naviTitle : title;
//        }else {
//            self.navView.titleStr = title;
//        }
//        self.webShareModel.shareTitle = title;
//    }];
//
//    NSString *htmlUrl = @"document.location.href";
//    WEAK_SELF(self);
//    [webView evaluateJavaScript:htmlUrl completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        STRONG_SELF(self);
//        /** 只为行政解忧使用 */
//        if (!LZMObjectIsNil(response)&&self.isGrocery) {
//            self.currentURLString = response;
//        }
//    }];
//}
//
///** 页面加载失败 */
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    /** 异步加载取消的时候,会报这个错误 NSURLErrorCancelled做正常操作,相反做异常处理 */
//    if (error.code == NSURLErrorCancelled) {
//        /** 被取消,啥也不用管 */
//        return;
//    }else {
//        /** 做异常处理 */
//        NSLog(@"webview didFailLoadWithError %@ ,and err is %@",webView.debugDescription, error.debugDescription);
//    }
//}
//
///** 页面捕捉回调 */
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    WEAK_SELF(self);
//    if ([message.name isEqualToString:kJSPayFunction]){
//        if (self.webViewPayBlock) {
//            STRONG_SELF(self);
//            _pool = self.webView.configuration.processPool;
//            self.webViewPayBlock(message.body, self);
//        }
//    }else {
//        LZMWebViewFunctionHandle *functionHandle = [LZMWebViewFunctionHandle new];
//        NSDictionary *dictP = @{@"webView" : self.webView,@"ctr" : self};
//        [functionHandle handleJsFunctionWitMethdName:message.name withjsCallbackName:message.body forObjDict:dictP];
//    }
//}
//
///** 页面发送请求之前，决定是否跳转 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    //不为web支付流程
//    if(![self checkWebPayForNavigationAction:navigationAction decisionHandler:decisionHandler]) {
//        NSURL *requestUrl = navigationAction.request.URL;
//        [LZMWebViewHelper underRequestUrlHandleEvent:requestUrl controller:self];
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}
//
///// 检查是否为web支付
//- (BOOL)checkWebPayForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    return [LZMWebPayService checkWebPayForNavigationAction:navigationAction decisionHandler:decisionHandler webView:self.webView];
//}
//
//#pragma mark - 通知
//- (void)loadPayDoneWeb:(NSNotification *)notice
//{
//    //回退触发微信支付的界面
//    [self clickNavBack];
//
//    NSURL *webUrl = notice.object;
//
//    NSString *webStr = [webUrl.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", kYiJiaYouHost] withString:@""];
//
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//    [self.webView loadRequest:request];
//}
//
#pragma mark - getter/setter
- (WKWebViewConfiguration *)config {
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        _config.preferences = [[WKPreferences alloc] init];
        _config.preferences.minimumFontSize = 8;
        _config.preferences.javaScriptEnabled = YES;
        _config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _config.processPool = [[WKProcessPool alloc] init];
        _config.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            _config.allowsAirPlayForMediaPlayback = YES;
        }
        /** CSS-Set */
        NSMutableString *javascript = [NSMutableString string];
        NSString *css = @""; //@"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        [javascript appendString:@"var style = document.createElement('style');"];
        [javascript appendString:@"style.type = 'text/css';"];
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
        [javascript appendString:@"style.appendChild(cssContent);"];
        [javascript appendString:@"document.body.appendChild(style);"];

        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [_config.userContentController addUserScript:noneSelectScript];
        [_config.userContentController addScriptMessageHandler:[[WkScriptMessageDelegate alloc] initWithDelegate:self] name:kJSPayFunction];
        [_config.userContentController addScriptMessageHandler:[[WkScriptMessageDelegate alloc] initWithDelegate:self] name:kJSCloseFunction];
        [_config.userContentController addScriptMessageHandler:[[WkScriptMessageDelegate alloc] initWithDelegate:self] name:kJSRefreshTokenFunction];
        [_config.userContentController addScriptMessageHandler:[[WkScriptMessageDelegate alloc] initWithDelegate:self] name:kJSGetUserInfoFunction];
        [_config.userContentController addScriptMessageHandler:[[WkScriptMessageDelegate alloc] initWithDelegate:self] name:kJSRequestScanQrCodeFunction];
    }
    return _config;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake( 0, 0, LZMDevWidth, LZMDevHeight - SafeAreaTopHeight) configuration:self.config];
        _webView.backgroundColor = LZMColor_C10;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = YES;
        _webView.multipleTouchEnabled = YES;
        _webView.userInteractionEnabled = YES;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.showsVerticalScrollIndicator = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (UIProgressView *)webviewProgressView {
    if (!_webviewProgressView) {
        _webviewProgressView = [[UIProgressView alloc] init];
        _webviewProgressView.tintColor = LZMColor_C1;
        _webviewProgressView.trackTintColor = LZMColor_C10;
        _webviewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _webviewProgressView;
}

- (LZMWebViewNavView *)navView {
    if (!_navView) {
        _navView = [[LZMWebViewNavView alloc]initWithFrame:CGRectMake(0, 0, LZMDevWidth, SafeAreaTopHeight) itemStyle:self.navItemStyle];
        [_navView setTitleStr:self.naviTitle];
        kWeakSelf;
        [_navView setLZMWebViewNavViewBlock:^(LZMWebViewNavViewTag type) {
            kStrongSelf;
            [strongSelf clickNavBackTagType:type];
        }];
    }
    return _navView;
}

//- (CustShareModel *)webShareModel
//{
//    if (_webShareModel == nil) {
//        _webShareModel = [CustShareModel new];
//        _webShareModel.shareTitle = self.title;
//        _webShareModel.sharedescription = [[SingleDataHelper sharedSingleDataHelper]getAppShareTextKey:webDes];
//        _webShareModel.sharedUrl = self.currentURLString;
//    }
//
//    return _webShareModel;
//}

@end

