//
//  NSString+LZMWebViewSDK.h
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LZMWebViewSDK)

- (NSString *)URLEncodedString; /**< 对URL 中的中文和 "|" "{" "}" 字符编码**/

@end

NS_ASSUME_NONNULL_END
