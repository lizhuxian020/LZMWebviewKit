//
//  NSString+LZMWebViewSDK.m
//  LZMWebViewSDK
//
//  Created by Main on 2020/8/7.
//  Copyright © 2020 SZ_LZM. All rights reserved.
//

#import "NSString+LZMWebViewSDK.h"

@implementation NSString (LZMWebViewSDK)

- (NSString *)URLEncodedString{
    return [self chineseCharsEncode];
}

- (NSString *)chineseCharsEncode{
    NSMutableArray *rangeArray = [NSMutableArray array];
    for(int i = 0; i< [self length] ; i++){
        unichar a = [self characterAtIndex:i];
        NSString *charString = [self substringWithRange:NSMakeRange(i, 1)];
        if( (a >= 0x4e00 && a <= 0x9fff) || [charString isEqualToString:@"|"] || [charString isEqualToString:@"{"] || [charString isEqualToString:@"}"]){ //判断是否为中文
            NSString *encodeString = [charString URL_Encoded_String];
            [rangeArray addObject:encodeString];
        }else{
            [rangeArray addObject:charString];
        }
    }
    return [rangeArray componentsJoinedByString:@""];
}

- (NSString *)URL_Encoded_String{
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

@end
