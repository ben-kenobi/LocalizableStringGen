//
//  YFStringsDiffConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsDiffConfig.h"

@implementation YFStringsDiffConfig
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
    self.deletedLocalizedStringFile=workingPath(@"Localizable_delete.strings");
    self.substitutedLocalizedStringFile=workingPath(@"Localizable_update.strings");
    self.unchangedLocalizedStringFile=workingPath(@"Localizable_unchanged.strings");
}
@end