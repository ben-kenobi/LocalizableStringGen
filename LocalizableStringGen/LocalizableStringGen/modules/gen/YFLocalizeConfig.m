//
//  YFLocalizeConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizeConfig.h"
NSString *const YF_LOCALIZE_BASE_WORKING_DIR = @"/Users/yf/Desktop/";
NSString *const YF_LOCALIZE_BASE_PROJECT_DIR = @"/Users/yf/Desktop/IOS/eufySecurity_ios/BatteryCam/";



//static NSString *const LOCALIZE_RE=@"NSLocalizedString.*?\\(.*?@\"(.+)\".*?,.*?\\)(?=.+NSLocalizedString)|NSLocalizedString.*?\\(.*?@\"(.+)\".*?,.*?\\)";
NSString *const LOCALIZE_RE = @"NSLocalizedString\\s*?\\(\\s*?@\"(.+?)\"\\s*?,\\s*?(?:NULL|nil|0)\\s*?\\)";

//NSString *const LOCALIZE_RE = @"NSLocalizedStringFromTable\\s*?\\(\\s*?@\"(.+?)\"\\s*?,\\s*?@\"BCBaseLocalizable\",\\s*?(?:NULL|nil|0)\\s*?\\)";
///total 1454
@implementation YFLocalizeConfig
-(instancetype)init{
    if(self = [super init]){
        [self defSetting];
//        [self tableSepcSetting];
    }
    return self;
}

-(void)defSetting{
    self.searchRE=LOCALIZE_RE;
    //文件夹需要 / 结尾
    self.srcDirs=@[
                   //        workingPath(@"temp/"),
//                   projectPath(@"BatteryCam/"),
//                   projectPath(@"Pods/"),
//                   projectPath(@"BCExtensionsCommonKit/")
                   projectPath(@"BatteryCam/src/modules/family/")
                   ];
    self.excludeFiles=@[
                        ];
    self.fileExts=@[@".m",@".mm"];
    self.srcLocalizedStringFile=workingPath(@"Localizable.strings");
    self.leftLocalizedStringFile=workingPath(@"Localizable_left.strings");
    self.destLocalizedStringFile=workingPath(@"Localizable_dest.strings");
    self.originDestLocalizedStringFile=workingPath(@"Localizable_dest_origin.strings");
    self.addedLocalizedStringFile=workingPath(@"Localizable_new.strings");
    self.substitutedLocalizedStringFile=workingPath(@"Localizable_substitute.strings");
    self.multiOccuredDestLocalizedStringFile=workingPath(@"Localizable_multy.strings");
}
-(void)tableSepcSetting{
    self.searchRE=LOCALIZE_RE;
    //文件夹需要 / 结尾
    self.srcDirs=@[
                           workingPath(@"temp/"),
                                      projectPath(@"BatteryCam/"),
                                      projectPath(@"Pods/"),
                                      projectPath(@"BCExtensionsCommonKit/")
                   ];
    self.excludeFiles=@[
                        ];
    self.fileExts=@[@".m",@".mm"];
    self.srcLocalizedStringFile=workingPath(@"BCBaseLocalizable.strings");
    self.leftLocalizedStringFile=workingPath(@"Localizable_left.strings");
    self.destLocalizedStringFile=workingPath(@"Localizable_dest.strings");
    self.originDestLocalizedStringFile=workingPath(@"Localizable_dest_origin.strings");
    self.substitutedLocalizedStringFile=workingPath(@"Localizable_substitute.strings");
    self.multiOccuredDestLocalizedStringFile=workingPath(@"Localizable_multy.strings");
}

@end


