//
//  YFLocalGroupHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFLocalGroupConfig.h"
NS_ASSUME_NONNULL_BEGIN
/**
 语言本地话工具，用于将分组后的语言文件与未分组的strings文件进行比较
 */
@interface YFLocalGroupHelper : NSObject
+(instancetype)startWithConfig:(YFLocalGroupConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
