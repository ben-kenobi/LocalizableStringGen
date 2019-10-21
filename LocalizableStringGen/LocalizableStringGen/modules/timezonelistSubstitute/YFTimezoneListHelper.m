//
//  YFTimezoneListHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2019/2/27.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFTimezoneListHelper.h"

@interface YFTimezoneListHelper()
@property (nonatomic,strong)YFTimezoneListConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end
@implementation YFTimezoneListHelper
+(instancetype)startWithConfig:(YFTimezoneListConfig *)config compCB:(void(^)(void))compCB{
    YFTimezoneListHelper *helper = [[YFTimezoneListHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self substitute];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}
#pragma mark - action


-(void)substitute{
    NSString *srcFile = self.config.srcPlist;
    NSString *subFile = self.config.substituteStrings;

    
    BOOL exist = [iFm fileExistsAtPath:srcFile isDirectory:0];
    NSAssert(exist, @"-----file not exists-----");
    exist = [iFm fileExistsAtPath:subFile isDirectory:0];
    NSAssert(exist, @"-----file not exists-----");
    
    NSArray *jsonary=[NSJSONSerialization JSONObjectWithData:iData4F(subFile) options:0 error:0];
    NSArray<NSDictionary *> *srcTZList = [NSArray arrayWithContentsOfFile:srcFile];
    NSMutableArray<NSDictionary *> *destTZList = [NSMutableArray array];
    for(int i=0;i<srcTZList.count;i++){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:srcTZList[i]];
        NSString *cityID = mdict[@"cityName"];
        for(NSDictionary *dict in jsonary){
            if([dict[@"timeId"] isEqualToString:cityID]){
                mdict[@"name"] = dict[@"timeZoneName"];
            }
        }
        [destTZList addObject:mdict];
    }

    // export
    [destTZList writeToFile:self.config.destPlist atomically:YES];
}

-(void)substitute2{
    NSString *srcFile = self.config.srcPlist;
    NSString *subFile = self.config.substituteStrings;

    
    BOOL exist = [iFm fileExistsAtPath:srcFile isDirectory:0];
    NSAssert(exist, @"-----file not exists-----");
    exist = [iFm fileExistsAtPath:subFile isDirectory:0];
    NSAssert(exist, @"-----file not exists-----");
    
    NSMutableDictionary *newTZDict=[YFLocalizeUtil localStringDictFrom:subFile];
    NSArray<NSDictionary *> *srcTZList = [NSArray arrayWithContentsOfFile:srcFile];
    NSMutableArray<NSDictionary *> *destTZList = [NSMutableArray array];
    for(int i=0;i<srcTZList.count;i++){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:srcTZList[i]];
        mdict[@"name"] = newTZDict[mdict[@"cityName"]];
        [destTZList addObject:mdict];
    }

    // export
    [destTZList writeToFile:self.config.destPlist atomically:YES];
}

@end
