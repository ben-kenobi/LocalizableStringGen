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
@property (nonatomic,strong)NSString *matchedLocalizedStringFile;

@property (nonatomic,strong)NSArray<NSString *> *fileExts;
@property (nonatomic,strong)NSArray<NSString *>*excludeFiles;

//路径与模块映射，可以根据tsv文件路径判断对应与哪个模块
@property (nonatomic,strong)NSDictionary *tsvfileNModuleDict;

@property (nonatomic,assign)NSInteger keyIdx;//tsv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//tsv文件中value的列
-(NSString *)moduleBy:(NSString *)tsvfile;
@property (nonatomic,assign)BOOL appendModulePrefix;//是否增加模块前缀

@property (nonatomic,strong)NSArray *commonAry;//公共字串

@end

NS_ASSUME_NONNULL_END
