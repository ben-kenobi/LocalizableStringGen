//
//  YFLocalCSVConvertHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFLocalCSVConvetConfig.h"
NS_ASSUME_NONNULL_BEGIN

/**
 strings->csv 或者csv转strings
 */
@interface YFLocalCSVConvertHelper : NSObject
+(instancetype)startWithConfig:(YFLocalCSVConvetConfig *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
