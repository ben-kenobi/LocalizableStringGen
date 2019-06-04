//
//  YFTranslatorHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2019/5/18.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFTranlatorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFTranslatorHelper : NSObject
+(instancetype)startWithConfig:(YFTranlatorConfig *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
