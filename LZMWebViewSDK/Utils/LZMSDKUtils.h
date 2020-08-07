//
//  LZMSDKUtils.h
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZMWebSDK.h"

#define LZMImage(imageName) [LZMSDKUtils getImage:imageName]
#define LZMFont(_size_) [LZMSDKUtils getFontWithSize:_size_ weightType:LZMFontWeightType_Regular]
#define LZMFontMedium(_size_) [LZMSDKUtils getFontWithSize:_size_ weightType:LZMFontWeightType_Medium]
#define kLZMSDKUtils [LZMSDKUtils shareUtils]

typedef enum : NSInteger {
    LZMFontWeightType_Regular,
    LZMFontWeightType_Medium,
    LZMFontWeightType_Semibold
}LZMFontWeightType;

NS_ASSUME_NONNULL_BEGIN

@interface LZMSDKUtils : NSObject

//初始化SDK的时候赋值给他
@property (nonatomic, weak) id<LZMWebSDKDelegate> sdk_delegate;

+ (instancetype)shareUtils;

+ (UIImage *)getImage:(NSString *)imageName;

+ (UIFont *)getFontWithSize:(CGFloat)size weightType:(LZMFontWeightType)type;

+ (void)makePhoneCall:(NSString *)phoneNum;

@end

NS_ASSUME_NONNULL_END
