//
//  YFLocalizeConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalizeConfig : NSObject
@property (nonatomic,strong)NSArray<NSString *>*srcDirs;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *leftLocalizedStringFile;
@property (nonatomic,strong)NSString *destLocalizedStringFile;
@property (nonatomic,strong)NSString *originDestLocalizedStringFile;
@property (nonatomic,strong)NSString *searchRE;
@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@end

NS_ASSUME_NONNULL_END
