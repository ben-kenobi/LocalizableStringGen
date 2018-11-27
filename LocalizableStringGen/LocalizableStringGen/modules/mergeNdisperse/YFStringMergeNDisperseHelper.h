//
//  YFStringMergeNDisperseHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/27.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFStringsMergeOrDisperseConfig.h"
NS_ASSUME_NONNULL_BEGIN
/**
 将strings文件合并或者按模块分散
 */
@interface YFStringMergeNDisperseHelper : NSObject
+(instancetype)startWithConfig:(YFStringsMergeOrDisperseConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
