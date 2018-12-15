//
//  YFStringUpdateHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/15.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringUpdateHelper.h"
@interface YFStringUpdateHelper()
@property (nonatomic,strong)YFStringsUpddateConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end
@implementation YFStringUpdateHelper
+(instancetype)startWithConfig:(YFStringsUpddateConfig *)config compCB:(void(^)(void))compCB{
    YFStringUpdateHelper *helper = [[YFStringUpdateHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self updaete];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}
#pragma mark - action
-(void)updaete{
    NSMutableDictionary *srcLocalizedDict=[YFLocalizeUtil localStringDictFrom:self.config.srcLocalizedStringFile];
    
    NSMutableDictionary *tarLocalizedDict=[YFLocalizeUtil localStringDictFrom:self.config.tarLocalizedStringFile];
    
    NSMutableString *addedMstr = [NSMutableString string];
    NSMutableString *updatedMstr = [NSMutableString string];
    
    
    for(NSString *key in tarLocalizedDict.allKeys){
        NSString *srcVal = srcLocalizedDict[key];
        NSString *tarval = tarLocalizedDict[key];
        if(![srcVal isEqualToString:tarval]){
            srcLocalizedDict[key] = tarval;
            if(srcVal){
                [YFLocalizeUtil append:updatedMstr key:key val:tarval];
                [YFLocalizeUtil append:updatedMstr key:iFormatStr(@"%@(old)",key) val:srcVal];
            }else{
                [YFLocalizeUtil append:addedMstr key:key val:tarval];
            }
        }
    }
    
    // export
    NSMutableString *newSrcMstr = [NSMutableString string];
    for(NSString *key in srcLocalizedDict.allKeys){
        NSString *val = srcLocalizedDict[key];
        [YFLocalizeUtil append:newSrcMstr key:key val:val];
    }
    [newSrcMstr writeToFile:self.config.srcLocalizedStringFile atomically:YES encoding:4 error:0];
    
    [updatedMstr writeToFile:self.config.substitutedLocalizedStringFile atomically:YES encoding:4 error:0];
    [addedMstr writeToFile:self.config.addedLocalizedStringFile atomically:YES encoding:4 error:0];
    
}

@end
