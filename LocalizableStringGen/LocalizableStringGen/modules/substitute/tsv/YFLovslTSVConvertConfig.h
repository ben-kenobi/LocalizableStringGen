//
//  YFLovslTSVConvertConfig.h
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLovslTSVConvertConfig : NSObject
@property (nonatomic,strong)NSString *stringsDir;
@property (nonatomic,strong)NSString *tsvDir;
@property (nonatomic,assign)BOOL revert;//NO:string->tsv,YES:tsv->strings
-(NSString *)destPathBySrcfile:(NSString *)path;



@property (nonatomic,assign)NSInteger keyIdx;//tsv文件中key的列
@property (nonatomic,assign)NSInteger valIdx;//tsv文件中value的列
@end

NS_ASSUME_NONNULL_END
