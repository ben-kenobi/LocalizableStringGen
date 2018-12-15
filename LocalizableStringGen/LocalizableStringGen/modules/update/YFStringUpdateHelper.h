//
//  YFStringUpdateHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/12/15.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFStringsUpddateConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFStringUpdateHelper : NSObject
+(instancetype)startWithConfig:(YFStringsUpddateConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
