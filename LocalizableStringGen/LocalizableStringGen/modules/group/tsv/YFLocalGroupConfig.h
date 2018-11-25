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
@property (nonatomic,strong)NSString *groupTSVDir;
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *leftLocalizedStringFile;

@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;


@property (nonatomic,assign)NSInteger keyIdx;//tsv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//tsv文件中value的列

@end

NS_ASSUME_NONNULL_END
