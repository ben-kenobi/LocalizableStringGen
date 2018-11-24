//
//  YFLocalGroupConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalGroupConfig : NSObject
@property (nonatomic,strong)NSString *groupCSVDir;
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *leftLocalizedStringFile;

@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;

@end

NS_ASSUME_NONNULL_END
