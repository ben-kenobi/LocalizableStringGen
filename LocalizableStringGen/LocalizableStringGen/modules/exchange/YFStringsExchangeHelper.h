//
//  YFStringsExchangeHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/26.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFStringExchangeConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 将strings文件key value位置交换
 */
@interface YFStringsExchangeHelper : NSObject
+(instancetype)startWithConfig:(YFStringExchangeConfig *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
