//
//  ViewController.m
//  LZMWebViewSDKExample
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import "ViewController.h"
#import <LZMWebViewSDK/LZMWebViewSDK.h>
#import "DemoSDKDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) DemoSDKDelegate *sdkDelegate;

@property (nonatomic, strong) LZMWebSDK *webSDK;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webSDK = [LZMWebSDK startWithDelegate:[DemoSDKDelegate new]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test_1.html" ofType:@""];
    [_webSDK loadHTMLWithPath:path withCurrentNavigationVC:self.navigationController];
    
    
}


@end
