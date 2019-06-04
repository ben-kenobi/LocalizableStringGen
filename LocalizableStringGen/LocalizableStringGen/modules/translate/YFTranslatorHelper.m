

//
//  YFTranslatorHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2019/5/18.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFTranslatorHelper.h"
#import "LKGoogleTranslator.h"

@interface YFTranslatorHelper()
@property (nonatomic,strong)YFTranlatorConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end
@implementation YFTranslatorHelper
+(instancetype)startWithConfig:(YFTranlatorConfig *)config compCB:(void(^)(void))compCB{
    YFTranslatorHelper *helper = [[YFTranslatorHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self tranlate];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}
#pragma mark - action
-(void)tranlate{
    NSString *srcFile = self.config.srcPlist;
    
    BOOL exist = [iFm fileExistsAtPath:srcFile isDirectory:0];
    NSAssert(exist, @"-----file not exists-----");
    
    NSArray<NSDictionary *> *srcTZList = [NSArray arrayWithContentsOfFile:srcFile];
    
    NSMutableString *destmstr=[NSMutableString string];
    for(int i=0;i<srcTZList.count;i++){
        NSDictionary *dict = srcTZList[i];
        NSString *srcname = dict[@"cityName"];
        NSString *destname = [self translateTzName:srcname fromLan:self.config.fromLan toLan:self.config.toLan];
        [YFLocalizeUtil append:destmstr key:srcname val:destname];
    }
    
    // export
    [destmstr writeToFile:[self.config destStrings] atomically:YES encoding:4 error:0];
}


-(NSString *)translateTzName:(NSString *)name fromLan:(NSString *)lan toLan:(NSString *)tolan{

    LKGoogleTranslator *translator = [[LKGoogleTranslator alloc] init];
    
    // replace slashes with commas, works better in Google Translate
    NSString *searchName = [name stringByReplacingOccurrencesOfString:@"/" withString:@","];
    searchName = [searchName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    NSString *translation = [translator translateText:searchName fromLanguage:lan toLanguage:tolan];
    translation = [translation stringByReplacingOccurrencesOfString:@"," withString:@"/"];
    translation = [translation stringByReplacingOccurrencesOfString:@"/ " withString:@"/"];
    translation = [translation stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        
    return translation;
}
@end
