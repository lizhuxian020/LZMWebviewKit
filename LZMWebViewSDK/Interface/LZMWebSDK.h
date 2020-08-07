//
//  LZMWebSDK.h
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

/**
 初始化该对象, 并使用
 */

#import <Foundation/Foundation.h>

@protocol LZMWebSDKDelegate <NSObject>

@optional
- (void)didClickTelephone:(NSString *_Nonnull)telephone;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LZMWebSDK : NSObject

+ (instancetype)startWithDelegate:(id<LZMWebSDKDelegate>)delegate;

- (void)loadURL:(NSURL *)url withCurrentNavigationVC:(UINavigationController *)naviVC;

- (void)loadHTMLWithPath:(NSString *)html_path withCurrentNavigationVC:(UINavigationController *)naviVC;

@end

NS_ASSUME_NONNULL_END
