//
//  YFLocalCSVConvetConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalCSVConvetConfig : YFBaseConfig
@property (nonatomic,strong)NSString *stringsDir;
@property (nonatomic,copy)NSArray<NSString *> *csvDirs;//需要c转成strings文件的csv文件夹数组
@property (nonatomic,assign)BOOL revert;//NO:string->csv,YES:csv->strings


@property (nonatomic,assign)NSInteger keyIdx;//csv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//csv文件中value的列

-(NSString *)destPathBySrcfile:(NSString *)path;
//csv - > strings
-(NSString *)stringDestPathBySrcfile:(NSString *)path dir:(NSString *)idir;
@end

NS_ASSUME_NONNULL_END
