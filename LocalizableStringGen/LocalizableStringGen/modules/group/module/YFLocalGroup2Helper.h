//
//  YFLocalGroup2Helper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFLocalGroup2Config.h"
NS_ASSUME_NONNULL_BEGIN
/**
 语言本地话工具，用于将strings中的字串按照在项目中所匹配到的路径分组
 */
@interface YFLocalGroup2Helper : NSObject
+(instancetype)startWithConfig:(YFLocalGroup2Config *)config compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
