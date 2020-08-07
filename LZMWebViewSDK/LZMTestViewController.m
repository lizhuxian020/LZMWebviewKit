//
//  LZMTestViewController.m
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import "LZMTestViewController.h"
#import <Masonry/Masonry.h>

@interface LZMTestViewController ()

@end

@implementation LZMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImage *image = nil;
    NSBundle *main = [NSBundle mainBundle];
    NSArray *path = [NSBundle allBundles];
    NSLog(@"%@", main);
//    [LZMSDKUtils shareUtils].;
//    NSLog(@"%@", LZMImage(@"meeting_room_detail_icon"));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
