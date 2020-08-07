//
//  LZMWebViewNavView.m
//  LZM_SmartEdifice
//
//  Created by Sui.H on 2019/4/17.
//  Copyright © 2019年 SZ_LZM. All rights reserved.
//

#import "LZMWebViewNavView.h"

@interface LZMWebViewNavView ()
/** 返回上一级 */
@property (nonatomic, strong) UIButton *backBtn;
/** 关闭 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 电话 */
@property (nonatomic, strong) UIButton *phoneBtn;
/** 分享 */
@property (nonatomic, strong) UIButton *shareBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/** 样式 */
@property (nonatomic, assign) NSInteger itemStyle;
@end

@implementation LZMWebViewNavView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame itemStyle:(NSInteger)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemStyle = style;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self setBackgroundColor:kNavi_BG_Color];
    [self addSubview:self.titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(170*LZMWIDTH_SCALE, 22));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-15);
    }];

    switch (_itemStyle) {
        case 0:
            [self defaultNavStyle];//默认样式 <
            break;
        case 1:
            [self allNavStyle];   //所有item < x phone 分享
            break;
        case 2:
            [self backCloseShareStyle]; //除客服电话 < x 分享
            break;
        case 3:
            [self backCloseStyle];//返回与关闭 < x
            break;
        case 4:
            [self closeNavStyle];//一个关闭 X
            break;
        default:
            break;
    }
}

#pragma mark --新增方法
- (BOOL)hasShare {
    return YES;
}

/** 默认样式 < */
- (void)defaultNavStyle {
    [self addSubview:self.backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self).offset(-18);
    }];
}

/** 一个关闭 X */
- (void)closeNavStyle {
    [self addSubview:self.closeBtn];
    [_closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15);
    }];
}

/** 除客服电话 < x 分享 */
- (void)backCloseShareStyle {
    [self addSubview:self.backBtn];
    [self addSubview:self.closeBtn];

    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self).offset(-18);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15);
    }];

    if ([self hasShare]) {
        /** 分享标记 */
        [self addSubview:self.shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.bottom.mas_equalTo(self).offset(-15);
        }];
    }
}

/** 所有item < x phone 分享 */
- (void)allNavStyle {
    [self addSubview:self.backBtn];
    [self addSubview:self.closeBtn];
    [self addSubview:self.phoneBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self).offset(-18);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15);
    }];
    /** 分享标记 */
    if ([self hasShare]) {
        [self addSubview:self.shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.bottom.mas_equalTo(self).offset(-15);
        }];
    }
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        /** 分享标记 */
        if ([self hasShare]) {
            make.right.mas_equalTo(self.shareBtn.mas_left).offset(-18);
        }else {
            make.right.mas_equalTo(self).offset(-15);
        }
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15);
    }];
}

/** 返回与关闭 < x */
- (void)backCloseStyle {
    [self addSubview:self.backBtn];
    [self addSubview:self.closeBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self).offset(-18);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15);
    }];
}

#pragma mark - public
- (void)setTitleStr:(NSString *)titleStr {
    self.titleLable.text = titleStr;
}

#pragma mark - incident
#pragma mark - private
- (void)didClickBtn:(UIButton *)btn {
    if (self.LZMWebViewNavViewBlock) {
        if (btn == _backBtn) {
            self.LZMWebViewNavViewBlock(LZMWebViewNavView_back);
        }
        if (btn == _closeBtn) {
            self.LZMWebViewNavViewBlock(LZMWebViewNavView_close);
        }
        if (btn == _shareBtn) {
            self.LZMWebViewNavViewBlock(LZMWebViewNavView_share);
        }
        if (btn == _phoneBtn) {
            self.LZMWebViewNavViewBlock(LZMWebViewNavView_phone);
        }
        if (btn == _backBtn) {
            self.LZMWebViewNavViewBlock(LZMWebViewNavView_back);
        }
    }
}

#pragma mark - delegate
#pragma mark - getter/setter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //TODO: 增大5个点, 点击范围
//        [_backBtn setEnlargeEdge:5];
        [_backBtn setImage:LZMImage(@"navigation_back_black") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_closeBtn setEnlargeEdge:5];
        [_closeBtn setImage:LZMImage(@"navigation_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_shareBtn setEnlargeEdge:5];
        [_shareBtn setImage:LZMImage(@"icon_navbar_share_black") forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_phoneBtn setEnlargeEdge:5];
        [_phoneBtn setImage:LZMImage(@"icon_navbar_call") forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = LZMFontMedium(18);
        _titleLable.textColor = LZMColor_C4;
    }
    return _titleLable;
}

@end
