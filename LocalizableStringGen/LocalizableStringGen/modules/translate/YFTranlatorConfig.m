

//
//  YFTranlatorConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2019/5/18.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFTranlatorConfig.h"

@implementation YFTranlatorConfig
-(instancetype)initWithFromLan:(NSString *)lan toLan:(NSString *)toLan{
    if(self = [super init]){
        self.fromLan = lan;
        self.toLan = toLan;
        self.srcPlist=workingPath(@"src.plist");
        self.destStrings=workingPath(iFormatStr(@"%@/localizedTimezone.strings",self.toLan));
    }return self;
}
-(void)initData{
   
}
@end
