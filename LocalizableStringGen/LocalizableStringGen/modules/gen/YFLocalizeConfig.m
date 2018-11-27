//
//  YFLocalizeConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizeConfig.h"

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
                   //        @"/Users/yf/Desktop/temp/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BatteryCam/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/Pods/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BCExtensionsCommonKit/"
                   
                   ];
    self.excludeFiles=@[
                        ];
    self.fileExts=@[@".m",@".mm"];
    self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable.strings";
    self.leftLocalizedStringFile=@"/Users/yf/Desktop/Localizable_left.strings";
    self.destLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest.strings";
    self.originDestLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest_origin.strings";
    self.addedLocalizedStringFile=@"/Users/yf/Desktop/Localizable_new.strings";
    self.substitutedLocalizedStringFile=@"/Users/yf/Desktop/Localizable_substitute.strings";
    self.multiOccuredDestLocalizedStringFile=@"/Users/yf/Desktop/Localizable_multy.strings";
}
-(void)tableSepcSetting{
    self.searchRE=LOCALIZE_RE;
    //文件夹需要 / 结尾
    self.srcDirs=@[
                   //        @"/Users/yf/Desktop/temp/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BatteryCam/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/Pods/",
                   @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BCExtensionsCommonKit/"
                   
                   ];
    self.excludeFiles=@[
                        ];
    self.fileExts=@[@".m",@".mm"];
    self.srcLocalizedStringFile=@"/Users/yf/Desktop/BCBaseLocalizable.strings";
    self.leftLocalizedStringFile=@"/Users/yf/Desktop/Localizable_left.strings";
    self.destLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest.strings";
    self.originDestLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest_origin.strings";
    self.substitutedLocalizedStringFile=@"/Users/yf/Desktop/Localizable_substitute.strings";
    self.multiOccuredDestLocalizedStringFile=@"/Users/yf/Desktop/Localizable_multy.strings";
}

@end
