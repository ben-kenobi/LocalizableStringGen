//
//  YFStringsExchangeHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/26.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsExchangeHelper.h"
@interface YFStringsExchangeHelper()
@property (nonatomic,strong)NSMutableDictionary *srcLocalizedStringDict;//从.strings文件中读取的key value
@property (nonatomic,strong)NSMutableDictionary *destLocalizedStringDict;

@property (nonatomic,strong)NSMutableString *multiOccuredMstring;

@property (nonatomic,strong)YFStringExchangeConfig *config;
@property (nonatomic,copy)void(^compCB)(void);
@end

@implementation YFStringsExchangeHelper
+(instancetype)startWithConfig:(YFStringExchangeConfig *)config compCB:(void(^)(void))compCB{
    YFStringsExchangeHelper *helper = [[YFStringsExchangeHelper alloc]init];
    helper.config=config;
    helper.multiOccuredMstring=[NSMutableString string];
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        self.srcLocalizedStringDict=[YFLocalizeUtil localStringDictFrom:self.config.srcLocalizedStringFile revert:YES multiOccuredString:self.multiOccuredMstring];
        self.destLocalizedStringDict=[NSMutableDictionary dictionaryWithDictionary:self.srcLocalizedStringDict];;
        [self exportStrings];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - export dest string
-(void)exportStrings{
    NSMutableString *destMstr = [NSMutableString string];
    for(NSString *key in self.destLocalizedStringDict.allKeys){
        NSString *val = self.destLocalizedStringDict[key];
        [YFLocalizeUtil append:destMstr key:key val:val];
    }
    [destMstr writeToFile:self.config.destLocalizedStringFile atomically:YES encoding:4 error:0];
    [self.multiOccuredMstring writeToFile:self.config.multiOccuredDestLocalizedStringFile atomically:YES encoding:4 error:0];
    
}

@end
