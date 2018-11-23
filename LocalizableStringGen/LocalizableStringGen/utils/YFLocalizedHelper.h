//
//  YFLocalizedHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalizedHelper : NSObject
+(instancetype)startWithConfig:(YFLocalizeConfig *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
