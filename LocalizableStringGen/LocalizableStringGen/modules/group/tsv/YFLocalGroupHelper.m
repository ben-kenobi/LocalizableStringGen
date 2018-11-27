

//
//  YFLocalGroupHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalGroupHelper.h"

@interface YFLocalGroupHelper()
{
    NSInteger tsvValCount;
    NSInteger matchCount;
}

@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;//从.strings文件中读取的key value
@property (nonatomic,strong)NSMutableDictionary *leftLocalizedStringDict;//同样是从.strings文件中读取的key value,但是删除被group文件匹配的key value后得到的剩余未匹配的key value


@property (nonatomic,strong)NSMutableDictionary *matchedLocalizedStringDict;//匹配到的字串，并且根据模块修改了key


@property (nonatomic,strong)YFLocalGroupConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalGroupHelper
+(instancetype)startWithConfig:(YFLocalGroupConfig *)config compCB:(void(^)(void))compCB{
    YFLocalGroupHelper *helper = [[YFLocalGroupHelper alloc]init];
    helper.config=config;
    
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile revert:YES];
    helper.leftLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile revert:NO];
    helper.matchedLocalizedStringDict=[NSMutableDictionary dictionary];
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self matchByGroup];
        [self exportStrings];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}


#pragma mark - group
-(void)matchByGroup{
    BOOL isdir=NO;
    NSString *dir = self.config.groupTSVDir;
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----file not exists-----");
    if(isdir){
        NSArray *ary = [iFm subpathsAtPath:dir];
        for(NSString *file in ary){
            [self compareStringsWithFile:file dir:dir];
        }
    }else{
        [self compareStringsWithFile:dir dir:@""];
    }
}
-(void)compareStringsWithFile:(NSString *)file dir:(NSString *)dir{
    NSString *tsvStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:self.config.fileExts  excludeFiles:self.config.excludeFiles];
    if(emptyStr(tsvStr))return;
    NSString *module = [self.config moduleBy:file];
    NSAssert(module!=nil, @"----module not found----");
    NSArray *tsvary = [tsvStr componentsSeparatedByString:@"\r\n"];
    NSMutableString *newtsvstr=[NSMutableString string];
    [newtsvstr appendFormat:@"%@\r\n",tsvary[0]];
    for(int i=1;i<tsvary.count;i++){//首行为标题，不处理
        NSString *enval = [self parseTSV:tsvary[i]];
        NSString *strkey=nil;
        if(enval){
            strkey=self.srcLocalizedStringDict[enval];
            tsvValCount++;
        }
        NSString *strwithoutFirstCol = tsvary[i];
        if(!emptyStr(tsvary[i]))
            strwithoutFirstCol=[tsvary[i] substringFromIndex:[tsvary[i] rangeOfString:@"\t"].location];
        if(strkey&&![self.config.commonAry containsObject:enval]){
            matchCount++;
            [self.leftLocalizedStringDict removeObjectForKey:strkey];
            
            NSString *newkey = @"";
            if(self.config.appendModulePrefix)
                newkey = iFormatStr(@"bc.%@.%@",module,strkey.lowercaseString);
            else
                newkey = strkey;
            
            [newtsvstr appendFormat:@"%@%@\r\n",newkey,strwithoutFirstCol];
            [self.matchedLocalizedStringDict setObject:enval forKey:strkey];
            
        }else{
            [newtsvstr appendFormat:@"%@\r\n",strwithoutFirstCol];
        }
    }

    [newtsvstr writeToFile:iFormatStr(@"%@%@",dir,file) atomically:YES encoding:4 error:nil];
}
-(NSString *)parseTSV:(NSString *)csv{

    NSArray *ary = [csv componentsSeparatedByString:@"\t"];
    if(ary.count>self.config.valIdx)return ary[self.config.valIdx];
    return nil;
}


#pragma mark - export
-(void)exportStrings{
    
    NSMutableString *leftMStr = [NSMutableString string];
    for(NSString *key in self.leftLocalizedStringDict.allKeys){
        NSString *val = self.leftLocalizedStringDict[key];
        [YFLocalizeUtil append:leftMStr key:key val:val];
    }
    [leftMStr writeToFile:self.config.leftLocalizedStringFile atomically:YES encoding:4 error:0];
    
    NSMutableString *matchedMStr = [NSMutableString string];
    for(NSString *key in self.matchedLocalizedStringDict.allKeys){
        NSString *val = self.matchedLocalizedStringDict[key];
        [YFLocalizeUtil append:matchedMStr key:key val:val];
    }
    [matchedMStr writeToFile:self.config.matchedLocalizedStringFile atomically:YES encoding:4 error:0];
    
}
@end
