//
//  YFFindNlocateConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFFindNlocateConfig : NSObject
@property (nonatomic,strong)NSString *groupTSVDir;
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *leftLocalizedStringFile;
@property (nonatomic,strong)NSString *matchedLocalizedStringFile;

@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;


@property (nonatomic,assign)NSInteger keyIdx;//tsv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//tsv文件中value的列
@end

NS_ASSUME_NONNULL_END
