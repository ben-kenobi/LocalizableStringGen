//
//  YFStringsDiffHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFStringsDiffConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFStringsDiffHelper : NSObject
+(instancetype)startWithConfig:(YFStringsDiffConfig *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
