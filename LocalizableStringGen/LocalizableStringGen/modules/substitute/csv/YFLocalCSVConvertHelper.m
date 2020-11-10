

//
//  YFLocalCSVConvertHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalCSVConvertHelper.h"
@interface YFLocalCSVConvertHelper()

@property (nonatomic,strong)YFLocalCSVConvetConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalCSVConvertHelper
+(instancetype)startWithConfig:(YFLocalCSVConvetConfig *)config compCB:(void(^)(void))compCB{
    YFLocalCSVConvertHelper *helper = [[YFLocalCSVConvertHelper alloc]init];
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
            [self convertToCSV];
        }
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - convert
-(void)convertToCSV{
    BOOL isdir=NO;
    NSString *dir = self.config.stringsDir;
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----file not exists-----");
    if(isdir){
        NSArray *ary = [iFm subpathsAtPath:dir];
        for(NSString *file in ary){
            [self convertStringsToCSV:file dir:dir];
        }
    }else{
        [self convertStringsToCSV:dir dir:@""];
    }
}
-(void)convertStringsToCSV:(NSString *)file dir:(NSString *)dir{
    NSString *srcStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:@[@".strings"]  excludeFiles:nil];
    if(!srcStr)return;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\"\\s*=\\s*\"" options:0 error:0];
    NSRegularExpression *reend = [NSRegularExpression regularExpressionWithPattern:@"\";$" options:NSRegularExpressionAnchorsMatchLines error:0];
    
    NSRegularExpression *quotre=[NSRegularExpression regularExpressionWithPattern:@"\\\\\"" options:(0) error:0];
    NSString *deststr = [re stringByReplacingMatchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length) withTemplate:@"\",\""];
    deststr=[reend stringByReplacingMatchesInString:deststr options:0 range:NSMakeRange(0, deststr.length) withTemplate:@"\","];
    
    deststr=[quotre stringByReplacingMatchesInString:deststr options:0 range:NSMakeRange(0, deststr.length) withTemplate:@"\\\\\"\""];
    deststr=iFormatStr(@",,\n%@",deststr);
    [deststr writeToFile:[self.config destPathBySrcfile:file] atomically:YES encoding:4 error:0];
}


#pragma mark - revert convert
-(void)convertToStrings{
    for(int i=0;i<self.config.csvDirs.count;i++){
        BOOL isdir=NO;
        NSString *dir = self.config.csvDirs[i];
        BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
        NSAssert(exist, @"-----file not exists-----");
        if(isdir){
            NSArray *ary = [iFm subpathsAtPath:dir];
            for(NSString *file in ary){
                [self convertCSVtoStrings:file dir:dir];
            }
        }else{
            [self convertCSVtoStrings:dir dir:@""];
        }
    }
}
-(void)convertCSVtoStrings:(NSString *)file dir:(NSString *)dir{
    NSString *csvStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:@[@".csv"] excludeFiles:nil];
    if(emptyStr(csvStr))return;
    NSArray *csvary = [csvStr componentsSeparatedByString:@"\r\n"];
    NSMutableString *destmstr=[NSMutableString string];
    for(int i=1;i<csvary.count;i++){ //首行为标题，不做处理
        NSArray *enval = [self parseCSV:csvary[i]];
        if(!enval)continue;
        NSString *key = [enval[0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if(emptyStr(key) || emptyStr(enval[1]))continue;
        [YFLocalizeUtil append:destmstr key:key val:enval[1]];
    }
    [destmstr writeToFile:[self.config stringDestPathBySrcfile:file dir:dir] atomically:YES encoding:4 error:0];
}
-(NSArray<NSString *> *)parseCSV:(NSString *)csv{

    NSMutableArray *ary = [NSMutableArray array];
    NSInteger fromidx = 0;
    NSString *beginStr = nil;
    for(int i = 0;i<csv.length;i++){
        NSString *ss = [csv substringWithRange:NSMakeRange(i, 1)];
        if(!beginStr){
            beginStr = ss;
            fromidx = i;
        }
        if([ss isEqualToString:@","]){
            if(![beginStr isEqualToString:@"\""]){
                [ary addObject: [csv substringWithRange:NSMakeRange(fromidx, i-fromidx)]];
                beginStr = nil;
                continue;
            }else{
                BOOL newSeg = NO;//是否是新一段
                for(int j = i-1; j>fromidx; j--){
                    NSString *substr = [csv substringWithRange:NSMakeRange(j, 1)];
                    if([substr isEqualToString:@"\""]){
                        newSeg = !newSeg;//奇数个"则算结束
                    }else{
                        //遇到非引号则判断结束
                        break;
                    }
                }
                if(newSeg){
                    [ary addObject: [self getCSVStrWithinQuotedStr:[csv substringWithRange:NSMakeRange(fromidx + 1, i-fromidx - 2)]]];
                    beginStr = nil;
                    continue;
                }
            }
        }else if(i == csv.length - 1){
            if([beginStr isEqualToString:@"\""]){
                NSInteger slen = (i-fromidx - 2 + 1);
                NSAssert(slen >= 0,@"字符长度小于0");
                [ary addObject: [self getCSVStrWithinQuotedStr:[csv substringWithRange:NSMakeRange(fromidx + 1, slen)]]];
            }else{
                [ary addObject: [csv substringWithRange:NSMakeRange(fromidx, i-fromidx+1)]];
            }
        }
        
    
    }
    
    if(ary.count>self.config.valIdx)return @[ary[self.config.keyIdx],ary[self.config.valIdx]];
    return nil;
}
-(NSString *)getCSVStrWithinQuotedStr:(NSString *)quotedStr{
    return [[quotedStr stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\""] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
}
@end
