//
//  LZMWebViewHelper.m
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/4.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import "LZMWebViewHelper.h"

/** webview */
//#import "LZMJumpCenter.h"//TODO_TEST
//#import "HZShareManager.h"//TODO_TEST

static NSString *const webCallObjc_Function = @"zzstc://";
static NSString *const webCallObjc_Itunes   = @"itunes.apple.com";
static NSString *const webCallObjc_Tel      = @"tel";
static NSString *const webCallObjc_OpenApp  = @"openapp";
NSString *const webCallObjc_ShowImage  = @"showimage";
static NSString *const LZM_CookiesKey = @"org.lzm.LZMWebCookies";

#define IOS10 [[UIDevice currentDevice].systemVersion floatValue] >= 10
#define IOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9

@implementation LZMWebViewHelper

+ (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableArray* pairs = [NSMutableArray array];

    for (NSString* key in param.keyEnumerator) {
        NSString *value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *query = [pairs componentsJoinedByString:@"&"];

#ifdef IOS9
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet];
    baseURL  = [baseURL stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
#else
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    NSString* url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@",baseURL, query];
    }
    else {
        url = [NSString stringWithFormat:@"%@?%@",baseURL, query];
    }
    return [NSURL URLWithString:url];
}

//+ (NSString *)phpCookieStringWithDomain:(NSString *)domain {
//    @autoreleasepool {
//        NSMutableString *cookieSting =[NSMutableString string];
//        NSArray *cookieArr = [self sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in cookieArr) {
//            if ([cookie.domain containsString:domain]) {
//                [cookieSting appendString:[NSString stringWithFormat:@"%@ = %@;",cookie.name,cookie.value]];
//            }
//        }
//        if (cookieSting.length > 1)[cookieSting deleteCharactersInRange:NSMakeRange(cookieSting.length - 1, 1)];
//
//        return (NSString *)cookieSting;
//    }
//}
//
//+ (NSMutableArray *)sharedHTTPCookieStorage {
//    @autoreleasepool {
//        NSMutableArray *cookiesArr = [NSMutableArray array];
//
//        /** 获取NSHTTPCookieStorage cookies  WKHTTPCookieStore 的cookie 已经同步*/
//        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
//        for (NSHTTPCookie *cookie in shareCookie.cookies){
//            [cookiesArr addObject:cookie];
//        }
//        /** 获取自定义存储的cookies */
//        NSMutableArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: LZM_CookiesKey]];
//
//        /** 删除过期的cookies */
//        for (int i = 0; i < cookies.count; i++) {
//            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
//            if (!cookie.expiresDate) {
//                [cookiesArr addObject:cookie]; //当cookie布设置国旗时间时，视cookie的有效期为长期有效。
//                continue;
//            }
//            if ([cookie.expiresDate compare:self.currentTime]) {
//                [cookiesArr addObject:cookie];
//            }else{
//                [cookies removeObject:cookie]; //清除过期的cookie。
//                i--;
//            }
//        }
//        /** 存储最新有效的cookies */
//        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:LZM_CookiesKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        return cookiesArr;
//    }
//}
//
//+ (void)syncCookiesToWKHTTPCookieStore:(WKHTTPCookieStore *)cookieStore API_AVAILABLE(macosx(10.13), ios(11.0)) {
//    NSMutableArray *cookieArr = [self sharedHTTPCookieStorage];
//    if (cookieArr.count == 0)return;
//    for (NSHTTPCookie *cookie in cookieArr) {
//        [cookieStore setCookie:cookie completionHandler:nil];
//    }
//}
//
//+ (NSDate *)currentTime {
//    return [NSDate dateWithTimeIntervalSinceNow:0];
//}
//
//+ (void)clearWebAllCacheFinish:(void (^)(BOOL, NSError *))block {
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
//        if (@available(iOS 9.0, *)) {
//            NSSet *cacheTypes = [NSSet setWithArray:
//                                       @[WKWebsiteDataTypeDiskCache,
//                                         WKWebsiteDataTypeOfflineWebApplicationCache,
//                                         WKWebsiteDataTypeMemoryCache,
//                                         WKWebsiteDataTypeLocalStorage,
//                                         WKWebsiteDataTypeSessionStorage,
//                                         WKWebsiteDataTypeIndexedDBDatabases,
//                                         WKWebsiteDataTypeWebSQLDatabases
//                                         ]];
//            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:cacheTypes modifiedSince:dateFrom completionHandler:^{
//                block ? block(YES,nil): NULL;
//            }];
//        } else {
//        }
//    } else {
//        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
//        NSError *errors;
//        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
//        block ? block(YES,errors): NULL;
//    }
//}
//
//+ (BOOL)underRequestUrlHandleEvent:(NSURL *)url controller:(UIViewController *)vc {
//    if ([url.absoluteString hasPrefix:webCallObjc_Function]){
//        NSDictionary *dict = [self JSONObjectWith_Data:url];
//        if (!LZMObjectIsNil(dict)) {
//            [self handleMessageWithParam:dict controller:vc];
//            return YES;
//        }
//    }
//    else if ([[url host] isEqualToString:webCallObjc_Itunes]) {
//        [self jumpItunes:url];
//        return YES;
//    }
//    else if ([[url scheme] isEqualToString:webCallObjc_Tel]) {
//        [self makePhoneCall:url.absoluteString];//TODO_TEST
//        return YES;
//    }
//    else if ([[url scheme] containsString:webCallObjc_OpenApp]){
//        [[UIApplication sharedApplication] openURL:url];
//        return YES;
//    }
//    else if ([[url scheme] containsString:webCallObjc_ShowImage]){
//        SEL sel = NSSelectorFromString(@"showWebImage:");
//        if ([vc respondsToSelector:sel]) {
//            SuppressPerformSelectorLeakWarning([vc performSelector:sel withObject:url.resourceSpecifier]);
//            return YES;
//        }
//    }
//    return NO;
//}
//
//+ (void)makePhoneCall:(NSString *)phoneNum{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIWindow *window = [UIApplication  sharedApplication].delegate.window;
//        NSMutableString * str ;
//        if ([phoneNum hasPrefix:@"tel"]){
//            str = [NSMutableString stringWithFormat:@"%@", phoneNum];
//        }else{
//            str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
//        }
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        callWebview.tag = 1314;
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [window addSubview:callWebview];
//    });
//}
//
//+ (void)handleMessageWithParam:(NSDictionary *)dict controller:(UIViewController *)vc {
//    NSDictionary *param;
//    if ([dict objectForKey:@"params"]) {
//        param = dict[@"params"];
//    }
//    if ([dict[@"action"] isEqualToString:@"updateApp"]){
//        [self jumpUpdateApp];
//        return;
//    }
//    if ([dict[@"action"] isEqualToString:@"wxShare"]){
//        [self wechatShare:param];
//        return;
//    }
//    if ( ([dict[@"action"] isEqualToString:@"jump"]&&param[@"jumpId"]&&param[@"jumpType"])||!LZMObjectIsNil(param[@"infoUrl"])){
//        if (![param objectForKey:@"jumpType"] || LZMObjectIsNil(param[@"jumpType"])) {
//            return;
//        }
//        [self handleJumpId:param[@"jumpId"] jumpType:[param[@"jumpType"]integerValue] jumpUrl:param[@"infoUrl"] title:param[@"title"] controller:vc];
//    }
//}
//
///** 升级app */
//+ (void)jumpUpdateApp {
//    NSString *appStoreUrl = [NSString stringWithFormat:@"%@%@?mt=8", kAppStoreUrl, kAPPId];
//    NSURL *appUrl = [NSURL URLWithString:appStoreUrl];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([[UIApplication sharedApplication] canOpenURL:appUrl]){
//            [[UIApplication sharedApplication] openURL:appUrl];
//        }
//    });
//}
//
///** 微信分享 */
//+ (void)wechatShare:(NSDictionary *)param {
//    [HZHud showHUD];
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:param[@"thumbUrl"]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        [HZHud dismissHUD];
//        if (!image){
//            image = [UIImage imageNamed:@"ic_logo"];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            Class HZShareManager = NSClassFromString(@"HZShareManager");
//            if ([HZShareManager respondsToSelector:@selector(shareManager)]) {
//                id Manager = [HZShareManager performSelector:@selector(shareManager)];
//                if ([Manager respondsToSelector:@selector(shareMediaWithTitle:description:coverImage:linkedUrl:sence:)]) {
//
//                }
//                NSInvocation *invo ;
//
//            }
//
////            [[HZShareManager shareManager] shareMediaWithTitle:param[@"title"]
////                                                   description:param[@"description"]
////                                                    coverImage:image
////                                                     linkedUrl:param[@"shareUrl"]
////                                                         sence:[param[@"shareType"] intValue]-1];//TODO_TEST
//        });
//    }];
//}
//
///** 跳转itunes */
//+ (void)jumpItunes:(NSURL *)url {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[UIApplication sharedApplication] openURL:url];
//    });
//}
//
///** webView根据类型跳转 */
//+ (void)handleJumpId:(NSString *)jumpId jumpType:(NSInteger)jumpType jumpUrl:(NSString *)jumpUrl title:(NSString *)title  controller:(UIViewController *)vc {
////    [LZMJumpCenter handleJumpType:jumpType jumpId:jumpId jumpUrl:jumpUrl title:title currentController:vc];//TODO_TEST
//    Class LZMJumpCenter = NSClassFromString(@"LZMJumpCenter");
//    if (LZMJumpCenter) {
//        if ([LZMJumpCenter respondsToSelector:@selector(handleJumpType:jumpId:jumpUrl:title:currentController:)]) {
//            [LZMJumpCenter performSelectorWithArgs:@selector(handleJumpType:jumpId:jumpUrl:title:currentController:), jumpId, jumpType, jumpUrl, title, vc];
//        }
//    }
//}
//
//+ (void)jumpSpecifiedController:(UIViewController *)vc specifiedVc:(UIViewController *)specified {
//    [vc.navigationController pushViewController:specified animated:true];
//}
//
//+ (NSDictionary *)JSONObjectWith_Data:(NSURL *)url {
//    NSString *jsonString = [url.absoluteString stringByRemovingPercentEncoding];
//    jsonString = [url.absoluteString URLDecodedString];
//    if (!jsonString){
//        jsonString = url.absoluteString;
//    }
//    jsonString = [jsonString substringFromIndex:8];
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//}
//
//- (void)shareMediaWithTitle:(NSString *)title
//                description:(NSString *)description
//                 coverImage:(UIImage *)coverImage
//                  linkedUrl:(NSString *)url
//                      sence:(int)sence {
//    Class HZShareManager = NSClassFromString(@"HZShareManager");
//    if (!HZShareManager) return;
//    SEL aSelector = @selector(shareMediaWithTitle:description:coverImage:linkedUrl:sence:);
//    NSMethodSignature*signature = [HZShareManager methodSignatureForSelector:aSelector];
//    //2、判断传入的方法是否存在
//    if (signature==nil) {
//        //传入的方法不存在 就抛异常
//        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
//        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
//        return;
//    }
//    //3、、创建NSInvocation对象
//    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
//    //4、保存方法所属的对象
//    invocation.target = HZShareManager;
//    invocation.selector = aSelector;
//
//    [invocation setArgument:&title atIndex:2];
//    [invocation setArgument:&description atIndex:3];
//    [invocation setArgument:&coverImage atIndex:4];
//    [invocation setArgument:&url atIndex:5];
//    [invocation setArgument:&sence atIndex:6];
//
//    [invocation invoke];
//}
//
//- (id)performSelector:(SEL)aSelector withObjects:(NSArray*)objects{
//    //1、创建签名对象
//    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:aSelector];
//
//
//    //2、判断传入的方法是否存在
//    if (signature==nil) {
//        //传入的方法不存在 就抛异常
//        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
//        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
//        return nil;
//    }
//
//
//    //3、、创建NSInvocation对象
//    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
//    //4、保存方法所属的对象
//    invocation.target = self;
//    invocation.selector = aSelector;
//
//
//    //5、设置参数
//    /*
//     当前如果直接遍历参数数组来设置参数
//     如果参数数组元素多余参数个数，那么就会报错
//     */
//    NSInteger arguments =signature.numberOfArguments-2;
//    /*
//     如果直接遍历参数的个数，会存在问题
//     如果参数的个数大于了参数值的个数，那么数组会越界
//     */
//    /*
//     谁少就遍历谁
//     */
//    NSUInteger objectsCount = objects.count;
//    NSInteger count = MIN(arguments, objectsCount);
//    for (int i = 0; i<count; i++) {
//        NSObject*obj = objects[i];
//        //处理参数是NULL类型的情况
//        if ([obj isKindOfClass:[NSNull class]]) {
//            obj = nil;
//        }
//        [invocation setArgument:&obj atIndex:i+2];
//
//    }
//    //6、调用NSinvocation对象
//    [invocation invoke];
//    //7、获取返回值
//    id res = nil;
//    //判断当前方法是否有返回值
////    NSLog(@"methodReturnType = %s",signature.methodReturnType);
////    NSLog(@"methodReturnTypeLength = %zd",signature.methodReturnLength);
//    if (signature.methodReturnLength!=0) {
//        //getReturnValue获取返回值
//        [invocation getReturnValue:&res];
//    }
//    return res;
//}

@end
