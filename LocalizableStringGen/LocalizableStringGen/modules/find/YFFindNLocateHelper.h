//
//  YFFindNLocateHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFFindNlocateConfig.h"
NS_ASSUME_NONNULL_BEGIN
/**
 语言本地话工具，用于将tsv文件与strings文件进行字符串比较,匹配上的添加key到tsv文件中，并导出一份未匹配列表
 */
@interface YFFindNLocateHelper : NSObject
+(instancetype)startWithConfig:(YFFindNlocateConfig *)config compCB:(void(^)(void))compCB;

@end

NS_ASSUME_NONNULL_END
