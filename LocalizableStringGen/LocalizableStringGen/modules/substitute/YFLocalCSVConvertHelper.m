

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
    
}
@end
