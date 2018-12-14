//
//  YFStringsMergeOrDisperseConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/27.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFStringsMergeOrDisperseConfig : NSObject
@property (nonatomic,strong)NSString *dispersedStringDir;
@property (nonatomic,strong)NSString *mergedStringFile;
@property (nonatomic,assign)BOOL reverse;//NO:merge  YES:disperse
-(NSString *)dispsersedPathByModule:(NSString *)module;
-(NSString *)moduleByKey:(NSString *)stringKey;
@end

NS_ASSUME_NONNULL_END
