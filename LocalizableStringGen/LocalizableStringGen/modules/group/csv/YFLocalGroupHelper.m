

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
    NSInteger csvValCount;
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
    
    helper.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile];
    helper.leftLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:helper.srcLocalizedStringDict];
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self matchByGroup];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}


#pragma mark - group
-(void)matchByGroup{
    BOOL isdir=NO;
    NSString *dir = self.config.groupCSVDir;
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
    NSString *csvStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:self.config.fileExts  excludeFiles:self.config.excludeFiles];
    if(emptyStr(csvStr))return;
    NSArray *csvary = [csvStr componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];
    for(int i=1;i<csvary.count;i++){
        NSString *enval = [self parseCSV:csvary[i]];
        if(!enval)continue;
        csvValCount++;
        NSString *strval = self.srcLocalizedStringDict[enval];
        if(strval){
            matchCount++;
            [self.leftLocalizedStringDict removeObjectForKey:enval];
        }
    }
}
-(NSString *)parseCSV:(NSString *)csv{

    NSArray *ary = [csv componentsSeparatedByString:@","];
    if(ary.count>=3)return ary[2];
    return nil;
}

@end
