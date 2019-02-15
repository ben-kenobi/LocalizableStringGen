

//
//  YFStringsDiffHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsDiffHelper.h"
@interface YFStringsDiffHelper()
@property (nonatomic,strong)YFStringsDiffConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end
@implementation YFStringsDiffHelper
+(instancetype)startWithConfig:(YFStringsDiffConfig *)config compCB:(void(^)(void))compCB{
    YFStringsDiffHelper *helper = [[YFStringsDiffHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self diff];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - actions

-(void)diff{
    NSMutableDictionary *srcLocalizedDict=[YFLocalizeUtil localStringDictFrom:self.config.srcLocalizedStringFile];
    
    NSMutableDictionary *tarLocalizedDict=[YFLocalizeUtil localStringDictFrom:self.config.tarLocalizedStringFile];
    
    NSMutableString *unchangeMstr = [NSMutableString string];
    NSMutableString *addedMstr = [NSMutableString string];
    NSMutableString *updatedMstr = [NSMutableString string];
    NSMutableString *notransMstr = [NSMutableString string];
    NSMutableDictionary *deleteLocalizedDict=[NSMutableDictionary dictionaryWithDictionary:srcLocalizedDict];
    [deleteLocalizedDict removeObjectsForKeys:tarLocalizedDict.allKeys];
    
    for(NSString *key in tarLocalizedDict.allKeys){
        NSString *srcVal = srcLocalizedDict[key];
        NSString *tarval = tarLocalizedDict[key];
        if(srcVal){
            if([srcVal isEqualToString:tarval]){
                [YFLocalizeUtil append:unchangeMstr key:key val:srcVal];
            }else if(!emptyStr(tarval)){
                [YFLocalizeUtil append:updatedMstr key:key val:tarval];
            }else{
               [YFLocalizeUtil append:notransMstr key:key val:srcVal];
            }
        }else{
            [YFLocalizeUtil append:addedMstr key:key val:tarval];
        }
    }
    
    // export
    NSMutableString *deleteMstr = [NSMutableString string];
    for(NSString *key in deleteLocalizedDict.allKeys){
        NSString *val = deleteLocalizedDict[key];
        [YFLocalizeUtil append:deleteMstr key:key val:val];
    }
    [deleteMstr writeToFile:self.config.deletedLocalizedStringFile atomically:YES encoding:4 error:0];
    [updatedMstr writeToFile:self.config.substitutedLocalizedStringFile atomically:YES encoding:4 error:0];
    [addedMstr writeToFile:self.config.addedLocalizedStringFile atomically:YES encoding:4 error:0];
    [unchangeMstr writeToFile:self.config.unchangedLocalizedStringFile atomically:YES encoding:4 error:0];
    [notransMstr writeToFile:self.config.noTranslatedLocalizedStringFile atomically:YES encoding:4 error:0];
}

@end
