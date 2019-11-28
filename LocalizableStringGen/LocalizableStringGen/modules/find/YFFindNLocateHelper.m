
//
//  YFFindNLocateHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFFindNLocateHelper.h"

@interface YFFindNLocateHelper()
{
    NSInteger tsvValCount;
    NSInteger matchCount;
}

@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;//从.strings文件中读取的key value
@property (nonatomic,strong)NSMutableDictionary *leftLocalizedStringDict;//同样是从.strings文件中读取的key value,但是删除被group文件匹配的key value后得到的剩余未匹配的key value


@property (nonatomic,strong)NSMutableDictionary *matchedLocalizedStringDict;//匹配到的字串，并且根据模块修改了key


@property (nonatomic,strong)YFFindNlocateConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFFindNLocateHelper
+(instancetype)startWithConfig:(YFFindNlocateConfig *)config compCB:(void(^)(void))compCB{
    YFFindNLocateHelper *helper = [[YFFindNLocateHelper alloc]init];
    helper.config=config;
    NSDictionary *srcDict = [YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile revert:YES];
    NSMutableDictionary *mdict = @{}.mutableCopy;
    for(NSString *key in srcDict.allKeys){
        if(emptyStr(key)) continue;
        [mdict setObject:srcDict[key] forKey:key.lowercaseString];
    }
    helper.srcLocalizedStringDict = mdict.copy;
    helper.leftLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:helper.config.srcLocalizedStringFile revert:NO];
    helper.matchedLocalizedStringDict=[NSMutableDictionary dictionary];
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self findNLocateStrings];
        [self exportStrings];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}


#pragma mark - group
-(void)findNLocateStrings{
    BOOL isdir=NO;
    NSString *dir = self.config.groupTSVDir;
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----file not exists-----");
    if(isdir){
        NSArray *ary = [iFm subpathsAtPath:dir];
        for(NSString *file in ary){
            [self findStringsFromFile:file dir:dir];
        }
    }else{
        [self findStringsFromFile:dir dir:@""];
    }
}
-(void)findStringsFromFile:(NSString *)file dir:(NSString *)dir{
    NSString *tsvStr = [YFLocalizeUtil strFromValidFile:file dir:dir fileExts:self.config.fileExts  excludeFiles:self.config.excludeFiles];
    if(emptyStr(tsvStr))return;
    NSArray *tsvary = [tsvStr componentsSeparatedByString:@"\r\n"];
    NSMutableString *newtsvstr=[NSMutableString string];
    [newtsvstr appendFormat:@"%@\r\n",tsvary[0]];
    for(int i=1;i<tsvary.count;i++){//首行为标题，不处理
        NSString *enval = [self parseTSV:tsvary[i]];
        NSString *strkey=nil;
        if(enval){
            if([enval isEqualToString:@"Alarm sounded due to %s\\'s motion detected"]){
                NSLog(@"");
            }
            NSString *envalkey = [enval stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"];
            envalkey = [envalkey stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
            envalkey = [envalkey stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            strkey=self.srcLocalizedStringDict[envalkey.lowercaseString];
            tsvValCount++;
        }
        NSString *strwithoutFirstCol = tsvary[i];
        if(!emptyStr(tsvary[i]))
            strwithoutFirstCol=[tsvary[i] substringFromIndex:[tsvary[i] rangeOfString:@"\t"].location];
        if(strkey){
            matchCount++;
            [self.leftLocalizedStringDict removeObjectForKey:strkey];
            
            NSString *newkey = @"";
            
            newkey = strkey;
            
            [newtsvstr appendFormat:@"%@%@\r\n",newkey,strwithoutFirstCol];
            [self.matchedLocalizedStringDict setObject:enval forKey:strkey];
            
        }else{
            [newtsvstr appendFormat:@"%@\r\n",strwithoutFirstCol];
        }
    }

    [newtsvstr writeToFile:iFormatStr(@"%@%@",dir,file) atomically:YES encoding:4 error:nil];
}
-(NSString *)parseTSV:(NSString *)tsv{

    NSArray *ary = [tsv componentsSeparatedByString:@"\t"];
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
