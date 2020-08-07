//
//  LZMWebViewFunctionHandle.h
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/10/28.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//
//  by Sui.H 处理js调用oc方法及实现功能

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZMWebViewFunctionHandle : NSObject

/**
 JS与OC相互调用处理

 @param functioNname 方法名字
 @param callbackName 调用JS方法名字
 @param objDict webview and 控制器
 */
- (void)handleJsFunctionWitMethdName:(NSString *)functioNname
                       withjsCallbackName:(NSString *)callbackName
                          forObjDict:(NSDictionary *)objDict;

@end

NS_ASSUME_NONNULL_END
