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
@property (nonatomic,strong)NSString *addedLocalizedStringFile;//项目中新增的字串
@property (nonatomic,strong)NSString *destLocalizedStringFile;
@property (nonatomic,strong)NSString *substitutedLocalizedStringFile;
@property (nonatomic,strong)NSString *originDestLocalizedStringFile;
@property (nonatomic,strong)NSString *multiOccuredDestLocalizedStringFile;//多次出现的w字串
@property (nonatomic,strong)NSString *searchRE;
@property (nonatomic,strong)NSArray<NSString *> *fileExts;

//替换时是否在strings文件转字典时候需要key value对调
@property (nonatomic,assign)BOOL revertReplace;
@end

NS_ASSUME_NONNULL_END
