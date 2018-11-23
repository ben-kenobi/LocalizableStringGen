//
//  YFLocalizeUtil.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalizeUtil : NSObject
+(void)append:(NSMutableString *)mstr key:(NSString *)key val:(NSString *)val;
+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile;


/**
将字典的key lowercase
 */
+(NSMutableDictionary *)localStringDictWithLowerKeyFrom:(NSString *)localstringFile;
@end

NS_ASSUME_NONNULL_END
