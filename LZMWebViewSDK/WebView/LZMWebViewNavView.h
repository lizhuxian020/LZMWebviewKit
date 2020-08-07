//
//  LZMWebViewNavView.h
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/4/17.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LZMWebViewNavViewTag) {
    /** 返回上一级 */
    LZMWebViewNavView_back  = 566,
    /** 关闭 */
    LZMWebViewNavView_close,
    /** 电话 */
    LZMWebViewNavView_phone,
    /** 分享 */
    LZMWebViewNavView_share,
};
NS_ASSUME_NONNULL_BEGIN

@interface LZMWebViewNavView : UIView

/**
 初始化并确定样式
 @param frame frame
 @param style 样式
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame itemStyle:(NSInteger)style;

/**
 按钮点击事件
 */
@property (nonatomic, copy) void(^LZMWebViewNavViewBlock)(LZMWebViewNavViewTag type);

@property (nonatomic, copy) NSString *titleStr;
@end

NS_ASSUME_NONNULL_END
