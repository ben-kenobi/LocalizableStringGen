//
//  YFStringsDiffConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFStringsDiffConfig : NSObject
@property (nonatomic,strong)NSString *srcLocalizedStringFile;//原始文件
@property (nonatomic,strong)NSString *tarLocalizedStringFile;//被比较文件
@property (nonatomic,strong)NSString *addedLocalizedStringFile;//比原始文件中新增的字串
@property (nonatomic,strong)NSString *deletedLocalizedStringFile;//比原始文件中减少的字串
@property (nonatomic,strong)NSString *substitutedLocalizedStringFile;//比原始文件中更新字串
@property (nonatomic,strong)NSString *unchangedLocalizedStringFile;//原始文件中不变的字串
@property (nonatomic,strong)NSString *noTranslatedLocalizedStringFile;//原始文件中没有翻译的字串

@end

NS_ASSUME_NONNULL_END
