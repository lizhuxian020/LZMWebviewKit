//
//  WkScriptMessageDelegate.h
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/5.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//
//  by Sui.H 用于防止内存溢出

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WkScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

NS_ASSUME_NONNULL_END
