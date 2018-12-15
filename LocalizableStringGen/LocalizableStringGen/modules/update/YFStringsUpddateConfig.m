


//
//  YFStringsUpddateConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/15.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsUpddateConfig.h"

@implementation YFStringsUpddateConfig
-(instancetype)init{
    if(self = [super init]){
        [self defSetting];
    }
    return self;
}

-(void)defSetting{
    self.srcLocalizedStringFile=workingPath(@"Localizable.strings");
    self.tarLocalizedStringFile=workingPath(@"Localizable_tar.strings");
    self.addedLocalizedStringFile=workingPath(@"Localizable_new.strings");
    self.substitutedLocalizedStringFile=workingPath(@"Localizable_update.strings");
}
@end
