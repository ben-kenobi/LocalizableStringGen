//
//  YFStringsDiffConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFStringsDiffConfig : YFBaseConfig
@property (nonatomic,assign)BOOL onlyExportMerged;//是否只导出merged文件
@property (nonatomic,copy)NSArray<NSString *> *srcLocalizedStringFiles;//原始文件




/**
 需要忽略的串，忽略的串处理方式为：1.在源文件中，则保留 2.不在源文件中，则直接丢弃
 */
@property (nonatomic,strong)NSDictionary *ignoreKeyDict;


-(NSString *)tarLocalizedStringFileBy:(NSInteger)idx;
-(NSString *)addedLocalizedStringFileBy:(NSInteger)idx;
-(NSString *)deletedLocalizedStringFileBy:(NSInteger)idx;
-(NSString *)substitutedLocalizedStringFileBy:(NSInteger)idx;
-(NSString *)unchangedLocalizedStringFileBy:(NSInteger)idx;
-(NSString *)noTranslatedLocalizedStringFileBy:(NSInteger)idx;


-(NSString *)ignoreLocalizedStringFileBy:(NSInteger)idx;

-(NSString *)destFileBy:(NSInteger)idx;
-(NSString *)destDir;

@end

NS_ASSUME_NONNULL_END
