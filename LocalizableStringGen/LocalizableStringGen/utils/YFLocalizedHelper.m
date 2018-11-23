//
//  YFLocalizedHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizedHelper.h"
@interface YFLocalizedHelper()
@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;
@property (nonatomic,strong)NSRegularExpression *RE;
@property (nonatomic,strong)NSMutableString *destMStr;
@property (nonatomic,strong)YFLocalizeConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalizedHelper
#pragma mark - start
+(instancetype)startWithConfig:(YFLocalizeConfig *)config compCB:(void(^)(void))compCB{
    YFLocalizedHelper *helper = [[YFLocalizedHelper alloc]init];
    helper.config=config;
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile];
    helper.RE=[NSRegularExpression regularExpressionWithPattern:helper.config.searchRE options:0 error:0];
    helper.destMStr = [NSMutableString string];
    helper.compCB = compCB;
    [helper start];
    return helper;
}

-(void)start{
    runOnGlobal(^{
        [self startGenStrByConfig];
        [self startReplaceStrByConfig];
        runOnMain(^{
           if(self.compCB)
               self.compCB();
        });
    });
}
#pragma mark - generate
-(void)startGenStrByConfig{
    for(NSString *dir in self.config.srcDirs){
        BOOL isdir = NO;
        BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
        if(!exist) continue;
        if(isdir){
            NSArray *ary = [iFm subpathsAtPath:dir];
            for(NSString *file in ary){
                [self extractStringsFrom:file dir:dir];
            }
        }else{
            [self extractStringsFrom:dir dir:@""];
        }
    }
}
-(void)extractStringsFrom:(NSString *)srcfile dir:(NSString *)dir {
    NSString *srcStr = [self strFromValidFile:srcfile dir:dir];
    if(emptyStr(srcStr))return;
    [self.RE enumerateMatchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *key = [self handleCheckResult:result srcStr:srcStr];
        [YFLocalizeUtil append:self.destMStr key:key val:key];
    }];
    [self.destMStr writeToFile:self.config.destLocalizedStringFile atomically:YES encoding:4 error:0];
}



-(NSString *)strFromValidFile:(NSString *)file dir:(NSString *)dir{
    NSString *path = iFormatStr(@"%@%@",dir,file);
    
    BOOL isDir = NO;
    BOOL exist = [iFm fileExistsAtPath:path isDirectory:&isDir];
    if(!exist||isDir)return nil;
    
    if([self.config.excludeFiles containsObject:path])return nil;
    
    BOOL valid = NO;
    for(NSString *ext in self.config.fileExts){
        if([path hasSuffix:ext]){
            valid=YES;
            break;
        }
    }
    if(!valid)return nil;
    return [NSString stringWithContentsOfFile:path encoding:4 error:0];
}


#pragma mark - replasce

-(void)startReplaceStrByConfig{
    
}



#pragma mark - Utils
-(NSString *)handleCheckResult:(NSTextCheckingResult *)result srcStr:(NSString *)srcStr{
    for(int i=1;i<result.numberOfRanges;i++){
        NSRange range = [result rangeAtIndex:i];
        if(range.location!=NSNotFound)
            return [srcStr substringWithRange:range];
    }
    NSAssert(NO, @"----wrong matching range-----");
    return @"";
}
@end
