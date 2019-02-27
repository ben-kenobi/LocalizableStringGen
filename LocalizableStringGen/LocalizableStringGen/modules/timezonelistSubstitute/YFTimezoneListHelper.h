//
//  YFTimezoneListHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2019/2/27.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFTimezoneListConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFTimezoneListHelper : NSObject
+(instancetype)startWithConfig:(YFTimezoneListConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
