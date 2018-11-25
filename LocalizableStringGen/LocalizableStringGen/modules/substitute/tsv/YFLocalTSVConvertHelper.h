//
//  YFLocalTSVConvertHelper.h
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFLovslTSVConvertConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 strings->tsv 或者tsv转strings
 */

@interface YFLocalTSVConvertHelper : NSObject
+(instancetype)startWithConfig:(YFLovslTSVConvertConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
