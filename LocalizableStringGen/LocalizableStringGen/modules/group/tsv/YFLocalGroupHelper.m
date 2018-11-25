

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


@property (nonatomic,strong)YFLocalGroupConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFLocalGroupHelper
+(instancetype)startWithConfig:(YFLocalGroupConfig *)config compCB:(void(^)(void))compCB{
    YFLocalGroupHelper *helper = [[YFLocalGroupHelper alloc]init];
    helper.config=config;
    
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile revert:YES];
    helper.leftLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:helper.srcLocalizedStringDict];
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
    NSArray *tsvary = [tsvStr componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];
    NSMutableString *newtsvstr=[NSMutableString string];
    [newtsvstr appendFormat:@"%@\n",tsvary[0]];
    for(int i=1;i<tsvary.count;i++){//首行为标题，不处理
        NSString *enval = [self parseTSV:tsvary[i]];
        NSString *strkey=nil;
        if(enval){
            strkey=self.srcLocalizedStringDict[enval];
            tsvValCount++;
        }
        if(strkey){
            matchCount++;
            [self.leftLocalizedStringDict removeObjectForKey:enval];
            [newtsvstr appendFormat:@"%@%@\n",strkey,tsvary[i]];
        }else{
            [newtsvstr appendFormat:@"%@\n",tsvary[i]];
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
    
}
@end
