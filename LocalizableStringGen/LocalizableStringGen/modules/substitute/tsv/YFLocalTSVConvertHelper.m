
//
//  YFLocalTSVConvertHelper.m
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalTSVConvertHelper.h"

@interface YFLocalTSVConvertHelper()

@property (nonatomic,strong)YFLovslTSVConvertConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalTSVConvertHelper
+(instancetype)startWithConfig:(YFLovslTSVConvertConfig *)config compCB:(void(^)(void))compCB{
    YFLocalTSVConvertHelper *helper = [[YFLocalTSVConvertHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}

#pragma mark - start
-(void)start{
    runOnGlobal(^{
        if(self.config.revert){
            [self convertToStrings];
        }else{
            [self convertToTSV];
        }
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - convert
-(void)convertToTSV{
    BOOL isdir=NO;
    NSString *dir = self.config.stringsDir;
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----file not exists-----");
    if(isdir){
        NSArray *ary = [iFm subpathsAtPath:dir];
        for(NSString *file in ary){
            [self convertStringsToTSV:file dir:dir];
        }
    }else{
        [self convertStringsToTSV:dir dir:@""];
    }
}
-(void)convertStringsToTSV:(NSString *)file dir:(NSString *)dir{
    NSString *srcStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:@[@".strings"]  excludeFiles:nil];
    if(!srcStr)return;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\"\\s*=\\s*\"" options:0 error:0];
    NSRegularExpression *reend = [NSRegularExpression regularExpressionWithPattern:@"\";$" options:NSRegularExpressionAnchorsMatchLines error:0];
    
    NSRegularExpression *quotre=[NSRegularExpression regularExpressionWithPattern:@"^\"" options:(NSRegularExpressionAnchorsMatchLines) error:0];
    
    NSString* deststr=[reend stringByReplacingMatchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length) withTemplate:@""];
    
    deststr=[quotre stringByReplacingMatchesInString:deststr options:0 range:NSMakeRange(0, deststr.length) withTemplate:@""];
    
    NSString *tab=@"\t";
    for(NSInteger i=1;i<self.config.valIdx;i++){
        tab=iFormatStr(@"%@%@",tab,@"\t");
    }
    deststr = [re stringByReplacingMatchesInString:deststr options:0 range:NSMakeRange(0, deststr.length) withTemplate:tab];
    deststr=iFormatStr(@"\t\t\n%@",deststr);
    [deststr writeToFile:[self.config tsvDestPathBySrcfile:file] atomically:YES encoding:4 error:0];
}


#pragma mark - revert convert

-(void)convertToStrings{
    for(int i=0;i<self.config.tsvDirs.count;i++){
        BOOL isdir=NO;
        NSString *dir = self.config.tsvDirs[i];
        BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
        NSAssert(exist, @"-----file not exists-----");
        if(isdir){
            NSArray *ary = [iFm subpathsAtPath:dir];
            for(NSString *file in ary){
                [self convertTSVtoStrings:file dir:dir];
            }
        }else{
            [self convertTSVtoStrings:dir dir:@""];
        }
    }
}
-(void)convertTSVtoStrings:(NSString *)file dir:(NSString *)dir{
    NSString *tsvStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:@[@".tsv"] excludeFiles:nil];
    if(emptyStr(tsvStr))return;
    NSArray *tsvary = [tsvStr componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];
    NSMutableString *destmstr=[NSMutableString string];
    for(int i=1;i<tsvary.count;i++){ //首行为标题，不做处理
        NSArray *enval = [self parseTSV:tsvary[i]];
        if(!enval)continue;
        [YFLocalizeUtil append:destmstr key:enval[0] val:enval[1]];
    }
    [destmstr writeToFile:[self.config stringDestPathBySrcfile:file dir:dir] atomically:YES encoding:4 error:0];
}
-(NSArray<NSString *> *)parseTSV:(NSString *)tsv{
    
    NSArray *ary = [tsv componentsSeparatedByString:@"\t"];
    if(ary.count>self.config.valIdx)return @[ary[self.config.keyIdx],ary[self.config.valIdx]];
    return nil;
}
@end
