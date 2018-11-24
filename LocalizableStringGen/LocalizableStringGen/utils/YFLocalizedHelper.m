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
@property (nonatomic,strong)NSMutableString *destMStr;//将destdict转换成strings文件形式的字串
@property (nonatomic,strong)NSMutableString *originDestMStr;//将匹配到的所有字串按顺序转换成strings文件形式的字串

@property (nonatomic,strong)NSMutableString *leftMStr;//将leftdict转换成strings文件形式的字串

@property (nonatomic,strong)NSMutableDictionary *substitutedLocalizedStringDict;//项目中被替换的字串
@property (nonatomic,strong)NSMutableString *substitutedMStr;//项目中被替换的字串

@property (nonatomic,strong)NSRegularExpression *RE;
@property (nonatomic,strong)YFLocalizeConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalizedHelper
#pragma mark - start
+(instancetype)startWithConfig:(YFLocalizeConfig *)config compCB:(void(^)(void))compCB{
    YFLocalizedHelper *helper = [[YFLocalizedHelper alloc]init];
    helper.config=config;
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile];
    helper.leftLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:helper.srcLocalizedStringDict];
    
    helper.destLocalizedStringDict=[NSMutableDictionary dictionary];
    helper.RE=[NSRegularExpression regularExpressionWithPattern:helper.config.searchRE options:0 error:0];
    helper.destMStr = [NSMutableString string];
    helper.leftMStr = [NSMutableString string];
    helper.originDestMStr = [NSMutableString string];
    
    helper.substitutedLocalizedStringDict=[NSMutableDictionary dictionary];
    helper.substitutedMStr=[NSMutableString string];
    
    helper.compCB = compCB;
    [helper start];
    return helper;
}

-(void)start{
    runOnGlobal(^{
        [self startGenStrByConfig];
        [self startReplaceStrKeyByValue];
        [self exportDestNLeft];
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
        //处理项目中匹配到的字符串
        NSString *key = [self handleCheckResult:result srcStr:srcStr range:nil];
        
        NSString *val = self.srcLocalizedStringDict[key];
        if(emptyStr(val)){
            val = key;
        }
        
        [self.destLocalizedStringDict setObject:val forKey:key];
        [self.leftLocalizedStringDict removeObjectForKey:key];
        
        
        [YFLocalizeUtil append:self.originDestMStr key:key val:val];
    }];
   
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
#pragma mark - export dest string N left string

-(void)exportDestNLeft{
    for(NSString *key in self.destLocalizedStringDict.allKeys){
        NSString *val = self.destLocalizedStringDict[key];
        [YFLocalizeUtil append:self.destMStr key:key val:val];
    }
    [self.destMStr writeToFile:self.config.destLocalizedStringFile atomically:YES encoding:4 error:0];
    
    for(NSString *key in self.leftLocalizedStringDict.allKeys){
        NSString *val = self.leftLocalizedStringDict[key];
        [YFLocalizeUtil append:self.leftMStr key:key val:val];
    }
    [self.leftMStr writeToFile:self.config.leftLocalizedStringFile atomically:YES encoding:4 error:0];
    
    
    for(NSString *key in self.substitutedLocalizedStringDict.allKeys){
        NSString *val = self.substitutedLocalizedStringDict[key];
        [YFLocalizeUtil append:self.substitutedMStr key:key val:val];
    }
    [self.substitutedMStr writeToFile:self.config.substitutedLocalizedStringFile atomically:YES encoding:4 error:0];
    
    [self.originDestMStr writeToFile:self.config.originDestLocalizedStringFile atomically:YES encoding:4 error:0];
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
    NSString *srcStr = [self strFromValidFile:srcfile dir:dir];
    if(emptyStr(srcStr))return;
    NSArray *ary = [self.RE matchesInString:srcStr options:0 range:NSMakeRange(0, srcStr.length)];
    
    if(ary.count<=0) return;
    
    NSString  *destStr = srcStr;
    BOOL hasSubstitute=NO;
    for(NSInteger i=ary.count-1;i>=0;i--){
        NSTextCheckingResult *result = ary[i];
        NSRange range={0};
        NSString *key = [self handleCheckResult:result srcStr:srcStr range:&range];
        
        NSString *val = self.destLocalizedStringDict[key];
        
        if(![val isEqualToString:key]){
            [self.substitutedLocalizedStringDict setObject:val forKey:key];
            hasSubstitute=YES;
            destStr = [destStr stringByReplacingCharactersInRange:range withString:val];
        }
    }
    
    if(hasSubstitute)
       [self write:destStr to:srcfile dir:dir];
}

-(void)write:(NSString *)destStr to:(NSString *)file dir:(NSString *)dir{
    if(emptyStr(destStr))return;
    NSString *path = iFormatStr(@"%@%@",dir,file);
    [destStr writeToFile:path atomically:YES encoding:4 error:0];
}



#pragma mark - Utils
-(NSString *)handleCheckResult:(NSTextCheckingResult *)result srcStr:(NSString *)srcStr range:(NSRange *)orange{
    for(int i=1;i<result.numberOfRanges;i++){
        NSRange range = [result rangeAtIndex:i];
        if(range.location!=NSNotFound){
            if(orange)
                *orange=range;
            return [srcStr substringWithRange:range];
        }
    }
    NSAssert(NO, @"----wrong matching range-----");
    return @"";
}
@end
