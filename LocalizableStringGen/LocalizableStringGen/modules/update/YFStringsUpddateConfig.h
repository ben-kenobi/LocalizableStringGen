//
//  YFStringsUpddateConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/12/15.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFStringsUpddateConfig : NSObject
@property (nonatomic,strong)NSString *srcLocalizedStringFile;//原始文件
@property (nonatomic,strong)NSString *tarLocalizedStringFile;//新文件
@property (nonatomic,strong)NSString *addedLocalizedStringFile;//比原始文件中新增的字串
@property (nonatomic,strong)NSString *substitutedLocalizedStringFile;//比原始文件中更新字串


@end

NS_ASSUME_NONNULL_END
