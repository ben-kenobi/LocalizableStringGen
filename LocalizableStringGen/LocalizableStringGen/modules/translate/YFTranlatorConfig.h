//
//  YFTranlatorConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2019/5/18.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFTranlatorConfig : YFBaseConfig
-(instancetype)initWithFromLan:(NSString *)lan toLan:(NSString *)toLan;
@property (nonatomic,strong)NSString *srcPlist;//原始文件
@property (nonatomic,strong)NSString *destStrings;//新文件
@property (nonatomic,strong)NSString *fromLan;
@property (nonatomic,strong)NSString *toLan;
@end

NS_ASSUME_NONNULL_END
