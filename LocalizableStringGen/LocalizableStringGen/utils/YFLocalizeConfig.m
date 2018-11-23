//
//  YFLocalizeConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizeConfig.h"

//static NSString *const LOCALIZE_RE=@"NSLocalizedString.*?\\(.*?@\"(.+)\".*?,.*?\\)(?=.+NSLocalizedString)|NSLocalizedString.*?\\(.*?@\"(.+)\".*?,.*?\\)";
static NSString *const LOCALIZE_RE = @"NSLocalizedString\\s*?\\(\\s*?@\"(.+?)\"\\s*?,\\s*?(?:NULL|nil|0)\\s*?\\)";
///total 1645
@implementation YFLocalizeConfig
-(instancetype)init{
    if(self = [super init]){
        self.searchRE=LOCALIZE_RE;
        //文件夹需要 / 结尾
        self.srcDirs=@[
           @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BatteryCam/",
                       @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/Pods/",
           @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BCExtensionsCommonKit/"
           
                       ];
        self.excludeFiles=@[
                            ];
        self.fileExts=@[@".m",@".mm"];
        self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable.strings";
        self.destLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest.strings";
    }
    return self;
}

@end
