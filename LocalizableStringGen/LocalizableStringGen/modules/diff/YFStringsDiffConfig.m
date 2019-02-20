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
   
    self.ignoreKeyDict = iRes4dict(@"ignorKeys.plist"); self.srcLocalizedStringFile=workingPath(@"Localizable.strings");
    self.tarLocalizedStringFile=workingPath(@"key_adjusted_strings_merged.strings");
    self.addedLocalizedStringFile=workingPath(@"Localizable_new.strings");
    self.deletedLocalizedStringFile=workingPath(@"Localizable_delete.strings");
    self.substitutedLocalizedStringFile=workingPath(@"Localizable_update.strings");
    self.unchangedLocalizedStringFile=workingPath(@"Localizable_unchanged.strings");
    self.noTranslatedLocalizedStringFile=workingPath(@"Localizable_notranslated.strings");
    self.ignoreLocalizedStringFile = workingPath(@"Localizable_ignore.strings");

}
@end
