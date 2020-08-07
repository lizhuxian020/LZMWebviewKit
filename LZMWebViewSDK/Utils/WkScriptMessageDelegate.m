//
//  WkScriptMessageDelegate.m
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/3/5.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import "WkScriptMessageDelegate.h"

@implementation WkScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
