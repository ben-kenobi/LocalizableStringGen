
//
//  YFStringMergeNDisperseHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/27.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringMergeNDisperseHelper.h"

@interface YFStringMergeNDisperseHelper()
@property (nonatomic,strong)YFStringsMergeOrDisperseConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end

@implementation YFStringMergeNDisperseHelper
+(instancetype)startWithConfig:(YFStringsMergeOrDisperseConfig *)config compCB:(void(^)(void))compCB{
    YFStringMergeNDisperseHelper *helper = [[YFStringMergeNDisperseHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        if(self.config.reverse)
           [self disperStrings];
        else
            [self mergeStrings];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - disperse
-(void)disperStrings{
    NSMutableDictionary *mergedLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:self.config.mergedStringFile];
    
    NSMutableDictionary<NSString *,NSMutableString *> *dispersedStringDict = [NSMutableDictionary dictionary];
    
    for(NSString *key in mergedLocalizedStringDict.allKeys){
        NSString *module = [self.config moduleByKey:key];
        NSMutableString *mstr = dispersedStringDict[module];
        if(!mstr){
            mstr = [NSMutableString string];
            dispersedStringDict[module] = mstr;
        }
        NSString *val = mergedLocalizedStringDict[key];
        [YFLocalizeUtil append:mstr key:key val:val];
    }
    
    for(NSString *module in dispersedStringDict.allKeys){
        NSMutableString *mstr = dispersedStringDict[module];
        [mstr writeToFile:[self.config dispsersedPathByModule:module] atomically:YES encoding:4 error:0];
    }
}


#pragma mark - merge
-(void)mergeStrings{
    BOOL isdir=NO;
    NSString *dir = self.config.dispersedStringDir;
    NSMutableString *mstr = [NSMutableString string];
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----file not exists-----");
    if(isdir){
        NSArray *ary = [iFm subpathsAtPath:dir];
        for(NSString *file in ary){
            [self mergeStrings:file dir:dir mstr:mstr];
        }
    }else{
        [self mergeStrings:dir dir:@"" mstr:mstr];
    }
    [mstr writeToFile:self.config.mergedStringFile atomically:YES encoding:4 error:0];
}

-(void)mergeStrings:(NSString *)file dir:(NSString *)dir mstr:(NSMutableString *)mstr{
    NSString *srcStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:@[@".strings"]  excludeFiles:nil];
    if(!srcStr)return;
    [mstr appendFormat:@"%@\n",srcStr];
//    NSArray *ary = [srcStr componentsSeparatedByString:@"\";"];
//    for(int i=0;i<ary.count-1;i++){
//        NSString *str = ary[i];
//        NSRange range = [str rangeOfString:@"\"\\s*=\\s*\"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, str.length)];
//
//        NSAssert(range.location!=NSNotFound, @"----- Range not found -----");
//
//        NSArray *sary = @[[str substringToIndex:range.location],[str substringFromIndex:range.location+range.length]];
//        NSString *key = [sary[0] substringFromIndex:[sary[0] rangeOfString:@"\""].location+1];
//        [YFLocalizeUtil append:mstr key:key val:sary[1]];
//    }
}


@end
