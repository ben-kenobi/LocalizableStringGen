//
//  YFLocalGroup2Config.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalGroup2Config : NSObject
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *leftLocalizedStringFile;

@property (nonatomic,strong)NSArray<NSString *>*srcDirs;
@property (nonatomic,strong)NSString *destDir;//将字符串按照模块倒出到的文件夹
@property (nonatomic,strong)NSString *conflictDestFile;//存在与两个或以上模块中的字串导出文件
@property (nonatomic,assign)BOOL diposeConflict;//如果发现字串存在与两个或更多模块，则只导出到第一个模块,默认为NO，则全部模块都保留一份

@property (nonatomic,assign)BOOL onlyKeepStringsExistInStringsFile;//只保留存在.strings文件中的字串

@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;
@property (nonatomic,strong)NSString *searchRE;


//路径与模块映射，可以根据文件路径判断对应与哪个模块
@property (nonatomic,strong)NSDictionary *pathNModuleDict;
@property (nonatomic,strong)NSArray *commonAry;//公共字串

-(NSString *)destPathByModule:(NSString *)module;
@end

NS_ASSUME_NONNULL_END
