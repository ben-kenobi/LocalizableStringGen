//
//  YFLovslTSVConvertConfig.h
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFLovslTSVConvertConfig : YFBaseConfig
@property (nonatomic,strong)NSString *stringsDir;//需要转成tsv的  strings 文件的文件夹
@property (nonatomic,copy)NSArray<NSString *> *tsvDirs;//需要c转成strings文件的tsv文件夹数组
@property (nonatomic,assign)BOOL revert;//NO:string->tsv,YES:tsv->strings


//tsv - > strings
-(NSString *)stringDestPathBySrcfile:(NSString *)path dir:(NSString *)idir;
//string - > tsv
-(NSString *)tsvDestPathBySrcfile:(NSString *)path;



@property (nonatomic,assign)NSInteger keyIdx;//tsv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//tsv文件中value的列
@end

NS_ASSUME_NONNULL_END
