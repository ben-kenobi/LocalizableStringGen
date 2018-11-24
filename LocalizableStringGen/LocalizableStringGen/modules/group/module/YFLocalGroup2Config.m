
//
//  YFLocalGroup2Config.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalGroup2Config.h"
extern  NSString *const LOCALIZE_RE;
@implementation YFLocalGroup2Config
-(instancetype)init{
    if(self = [super init]){
        self.searchRE=LOCALIZE_RE;
        //文件夹需要 / 结尾
        self.srcDirs=@[
           @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BatteryCam/",
           @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/Pods/",
           @"/Users/yf/Desktop/IOS/batterycam/ios/BatteryCam/BCExtensionsCommonKit/"
                       ];
        self.destDir=@"/Users/yf/Desktop/stringsDir/";
        self.fileExts=@[@".m",@".mm"];
        self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable.strings";
        self.leftLocalizedStringFile=@"/Users/yf/Desktop/Localizable_left.strings";
        self.conflictDestFile=@"/Users/yf/Desktop/Localizable_conflict.strings";
        self.pathNModuleDict=iRes4dict(@"pathNmoduleMap.plist");
        
        self.commonAry=@[@"YES",@"Yes",@"NO",@"No",@"no",@"yes",@"All",@"ALL",@"Ok",@"Edit",@"Edit",@"Save",@"Sure",@"Confirm",@"OK",@"Cancel",@"Retry",@"Send",@"Help",@"Email",@"Next",@"Reminder",@"Nickname",@"Delete",@"Medium",@"Low",@"High",@"Alert",@"Warning",@"Got it",@"Not Now",@"Don't show again",@"Password",@"Try again",@"Close",@"Camera",@"Continue",@"Settings",@"Name",@"Finish",@"Back",@"Loading",@"From",@"To",@"Day",@"OPEN",@"Open",@"CLOSE",@"Close",@"Mail",@"Sending",@"Accept",@"Resend",@"Reset"
                         ];
        
    }
    return self;
}
-(NSString *)destPathByModule:(NSString *)module{
    BOOL isDir = NO;
    BOOL exist = [iFm fileExistsAtPath:self.destDir isDirectory:&isDir];

    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:self.destDir withIntermediateDirectories:YES attributes:0 error:0];
    }
    
    return iFormatStr(@"%@%@.strings",self.destDir,module);
}
@end
