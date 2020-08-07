//
//  LZMWebSDK.m
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import "LZMWebSDK.h"
#import "LZMWebController.h"

@interface LZMWebSDK ()

@property (nonatomic, weak) id<LZMWebSDKDelegate> sdk_delegate;

@end

@implementation LZMWebSDK

+ (instancetype)startWithDelegate:(id<LZMWebSDKDelegate>)delegate {
    LZMWebSDK *sdk = [LZMWebSDK new];
    sdk.sdk_delegate = delegate;
    //赋值给utils
    [LZMSDKUtils shareUtils].sdk_delegate = delegate;
    return sdk;
}

- (void)loadURL:(NSURL *)url withCurrentNavigationVC:(UINavigationController *)naviVC {
    
}

- (void)loadHTMLWithPath:(NSString *)html_path withCurrentNavigationVC:(UINavigationController *)naviVC {
    LZMWebController *vc = [LZMWebController new];
    [vc loadLocalHTMLWithFileName:html_path];
    [naviVC pushViewController:vc animated:YES];
}

@end
