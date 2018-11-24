//
//  YFLocalizedHelper.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 语言本地话工具，用于将项目中字串倒出，跟strings文件中比较，生成新的strings文件，并将项目中的所有语言key值替换成新strings文件中的value值
 */
@interface YFLocalizedHelper : NSObject
+(instancetype)startWithConfig:(YFLocalizeConfig *)config gen:(BOOL)gen  compCB:(void(^)(void))compCB;
@end

NS_ASSUME_NONNULL_END
