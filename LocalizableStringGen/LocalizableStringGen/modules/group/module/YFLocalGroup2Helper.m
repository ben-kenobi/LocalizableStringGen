
//
//  YFLocalGroup2Helper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalGroup2Helper.h"
@interface YFLocalGroup2Helper()
@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;//从.strings文件中读取的key value
@property (nonatomic,strong)NSMutableDictionary *leftLocalizedStringDict;//同样是从.strings文件中读取的key value,但是删除被匹配后的key value后得到的剩余未匹配的key value

@property (nonatomic,strong)NSMutableDictionary<NSString *,NSMutableDictionary *> *groupedDicts;


@property (nonatomic,strong)NSRegularExpression *RE;

@property (nonatomic,strong)NSMutableDictionary *strNmoduleMap;
@property (nonatomic,strong)NSMutableDictionary *conflictDict;//存在与两个或更多模块的字串

@property (nonatomic,strong)YFLocalGroup2Config *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalGroup2Helper
+(instancetype)startWithConfig:(YFLocalGroup2Config *)config compCB:(void(^)(void))compCB{
    YFLocalGroup2Helper *helper = [[YFLocalGroup2Helper alloc]init];
    helper.config=config;
    
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile];
    
    helper.leftLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:helper.srcLocalizedStringDict];
    
    helper.RE=[NSRegularExpression regularExpressionWithPattern:helper.config.searchRE options:0 error:0];
    helper.groupedDicts=[NSMutableDictionary dictionary];
    helper.strNmoduleMap=[NSMutableDictionary dictionary];
    helper.conflictDict=[NSMutableDictionary dictionary];

    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self startGroupStrings];
        [self exportStrings];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}


#pragma mark - group
-(void)startGroupStrings{
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
            if(self.config.onlyKeepStringsExistInStringsFile)
                return;
            val = key;
        }
        [self.leftLocalizedStringDict removeObjectForKey:key];
        
        
        if(self.config.diposeConflict){
            //检查是否字串已经存在与另一个模块
            NSString *curmodule = self.strNmoduleMap[val];
            if(!curmodule){
                NSString *module = [self addStringToGroup:val file:srcfile dir:dir];
            }
        }else{
            NSString *module = [self addStringToGroup:val file:srcfile dir:dir];
            
            
            //检查是否字串已经存在与另一个模块
            NSString *curmodule = self.strNmoduleMap[val];
            if(curmodule==nil || [module isEqualToString:curmodule]){
                [self.strNmoduleMap setObject:module forKey:val];
            }else{
                [self.conflictDict setObject:iFormatStr(@"%@-%@",module,curmodule) forKey:val];
            }
        }
        
    }];
    
}


#pragma mark - export dest string N left string

-(void)exportStrings{
   
    NSMutableString *leftMStr = [NSMutableString string];
    for(NSString *key in self.leftLocalizedStringDict.allKeys){
        NSString *val = self.leftLocalizedStringDict[key];
        [YFLocalizeUtil append:leftMStr key:key val:val];
    }
    [leftMStr writeToFile:self.config.leftLocalizedStringFile atomically:YES encoding:4 error:0];
    
    
    NSMutableString *conflictMStr = [NSMutableString string];
    for(NSString *key in self.conflictDict.allKeys){
        NSString *val = self.conflictDict[key];
        [YFLocalizeUtil append:conflictMStr key:key val:val];
    }
    [conflictMStr writeToFile:self.config.conflictDestFile atomically:YES encoding:4 error:0];
    
    for(NSString *key in self.groupedDicts.allKeys){
        NSMutableString *mStr = [NSMutableString string];

        NSMutableDictionary *dict =  self.groupedDicts[key];
        for(NSString *key in dict.allKeys){
            NSString *val = dict[key];
            [YFLocalizeUtil append:mStr key:key val:val];
        }
        [mStr writeToFile:[self.config destPathByModule:key] atomically:YES encoding:4 error:0];
    }
    
}

#pragma mark - Utils
-(NSString *)addStringToGroup:(NSString *)str file:(NSString *)file dir:(NSString *)dir{
    NSString *path = iFormatStr(@"%@%@",dir,file);
    NSString *module = @"other";
    
    if([self.config.commonAry containsObject:str]){
        module=@"common";
    }else{
        for(NSString *key in self.config.pathNModuleDict.allKeys){
            if([path hasPrefix:key]){
                module=self.config.pathNModuleDict[key];
                break;
            }
        }
    }
    [self addStringToGroup:str module:module];
    return module;
}
-(void)addStringToGroup:(NSString *)str module:(NSString *)module{
    NSMutableDictionary *mdict = self.groupedDicts[module];
    if(!mdict){
        mdict=[NSMutableDictionary dictionary];
        [self.groupedDicts setObject:mdict forKey:module];
    }
    [mdict setObject:str forKey:iFormatStr(@"bc.%@.%@",module,str.lowercaseString)];
}



@end

