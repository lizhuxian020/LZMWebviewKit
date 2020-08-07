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
    [self.navigationController pushViewController:[LZMTestViewController new] animated:YES];
}


@end
