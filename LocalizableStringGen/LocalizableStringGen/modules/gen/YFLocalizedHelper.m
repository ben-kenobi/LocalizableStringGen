//
//  YFLocalizedHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizedHelper.h"
@interface YFLocalizedHelper()
@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;//从.strings文件中读取的key value
@property (nonatomic,strong)NSMutableDictionary *leftLocalizedStringDict;//同样是从.strings文件中读取的key value,但是删除被匹配后的key value后得到的剩余未匹配的key value

@property (nonatomic,strong)NSMutableDictionary *destLocalizedStringDict;//将迭代项目中的所有key 和 .string文件的value匹配后存放的dict，如果没有value，则value = key
@property (nonatomic,strong)NSMutableString *originDestMStr;//将匹配到的所有字串按顺序转换成strings文件形式的字串

@property (nonatomic,strong)NSMutableDictionary *substitutedLocalizedStringDict;//项目中被替换的字串

@property (nonatomic,strong)NSRegularExpression *RE;
@property (nonatomic,strong)YFLocalizeConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalizedHelper
#pragma mark - start
+(instancetype)startWithConfig:(YFLocalizeConfig *)config gen:(BOOL)gen compCB:(void(^)(void))compCB{
    YFLocalizedHelper *helper = [[YFLocalizedHelper alloc]init];
    helper.config=config;
    helper.leftLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:helper.srcLocalizedStringDict];
    
    helper.destLocalizedStringDict=[NSMutableDictionary dictionary];
    helper.RE=[NSRegularExpression regularExpressionWithPattern:helper.config.searchRE options:0 error:0];
    helper.originDestMStr = [NSMutableString string];
    
    helper.substitutedLocalizedStringDict=[NSMutableDictionary dictionary];
    
    helper.compCB = compCB;
    
    if(gen)
        [helper startGen];
    else
        [helper startReplace];
    return helper;
}

-(void)startGen{
    runOnGlobal(^{
        self.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:self.config.srcLocalizedStringFile];
        [self startGenStrByConfig];
        [self exportStrings];
        runOnMain(^{
           if(self.compCB)
               self.compCB();
        });
    });
}

-(void)startReplace{
    runOnGlobal(^{
        self.destLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:self.config.destLocalizedStringFile];
        [self startReplaceStrKeyByValue];
        [self exportStrings];
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
    NSString *srcStr = [YFLocalizeUtil strFromValidFile:srcfile dir:dir fileExts:self.config.fileExts  excludeFiles:self.config.excludeFiles];
    if(emptyStr(srcStr))return;
    [self.RE enumerateMatchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        //处理项目中匹配到的字符串
        NSString *key = [YFLocalizeUtil handleCheckResult:result srcStr:srcStr range:nil];
        
        NSString *val = self.srcLocalizedStringDict[key];
        if(emptyStr(val)){
            val = key;
        }
        
        [self.destLocalizedStringDict setObject:val forKey:key];
        [self.leftLocalizedStringDict removeObjectForKey:key];
        
        
        [YFLocalizeUtil append:self.originDestMStr key:key val:val];
    }];
   
}






#pragma mark - replasce
-(void)startReplaceStrKeyByValue{
    for(NSString *dir in self.config.srcDirs){
        BOOL isdir = NO;
        BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
        if(!exist) continue;
        if(isdir){
            NSArray *ary = [iFm subpathsAtPath:dir];
            for(NSString *file in ary){
                [self extractNReplaceStringsFrom:file dir:dir];
            }
        }else{
            [self extractNReplaceStringsFrom:dir dir:@""];
        }
    }
}

//使用
-(void)extractNReplaceStringsFrom:(NSString *)srcfile dir:(NSString *)dir {
    NSString *srcStr = [YFLocalizeUtil strFromValidFile:srcfile dir:dir fileExts:self.config.fileExts  excludeFiles:self.config.excludeFiles];
    if(emptyStr(srcStr))return;
    NSArray *ary = [self.RE matchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length)];
    
    if(ary.count<=0) return;
    
    NSString  *destStr = srcStr;
    BOOL hasSubstitute=NO;
    for(NSInteger i=ary.count-1;i>=0;i--){
        NSTextCheckingResult *result = ary[i];
        NSRange range={0};
        NSString *key = [YFLocalizeUtil handleCheckResult:result srcStr:srcStr range:&range];
        
        NSString *val = self.destLocalizedStringDict[key];
        NSAssert(val!=nil, @"value not found");
        if(![val isEqualToString:key]){
            [self.substitutedLocalizedStringDict setObject:val forKey:key];
            hasSubstitute=YES;
            destStr = [destStr stringByReplacingCharactersInRange:range withString:val];
        }
    }
    
    if(hasSubstitute)
       [YFLocalizeUtil write:destStr to:srcfile dir:dir];
}




#pragma mark - export dest string N left string

-(void)exportStrings{
    NSMutableString *destMstr = [NSMutableString string];
    for(NSString *key in self.destLocalizedStringDict.allKeys){
        NSString *val = self.destLocalizedStringDict[key];
        [YFLocalizeUtil append:destMstr key:key val:val];
    }
    [destMstr writeToFile:self.config.destLocalizedStringFile atomically:YES encoding:4 error:0];
    
    
    NSMutableString *leftMStr = [NSMutableString string];
    for(NSString *key in self.leftLocalizedStringDict.allKeys){
        NSString *val = self.leftLocalizedStringDict[key];
        [YFLocalizeUtil append:leftMStr key:key val:val];
    }
    [leftMStr writeToFile:self.config.leftLocalizedStringFile atomically:YES encoding:4 error:0];
    
    
    NSMutableString *substitutedMStr = [NSMutableString string];
    for(NSString *key in self.substitutedLocalizedStringDict.allKeys){
        NSString *val = self.substitutedLocalizedStringDict[key];
        [YFLocalizeUtil append:substitutedMStr key:key val:val];
    }
    [substitutedMStr writeToFile:self.config.substitutedLocalizedStringFile atomically:YES encoding:4 error:0];
    
    [self.originDestMStr writeToFile:self.config.originDestLocalizedStringFile atomically:YES encoding:4 error:0];
}


@end
