

//
//  YFLocalGroupConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalGroupConfig.h"
#import "YFLocalGroup2Config.h"
@implementation YFLocalGroupConfig
-(instancetype)init{
    if(self = [super init]){
        //文件夹需要 / 结尾
        self.groupTSVDir=workingPath(@"tsvGroup/");
        self.fileExts=@[@".tsv"];
        self.srcLocalizedStringFile=workingPath(@"Localizable.strings");
        self.leftLocalizedStringFile=workingPath(@"Localizable_left.strings");
        self.matchedLocalizedStringFile=workingPath(@"Localizable_matched.strings");
        
        //根据tsv文件值的位置
        self.keyIdx=0;
        self.valIdx=2;
        self.tsvfileNModuleDict=iRes4dict(@"tsvFileNModuleMap.plist");
        self.commonAry=[YFLocalGroup2Config commonStrAry];
        self.appendModulePrefix=NO;
    }
    return self;
}

-(NSString *)moduleBy:(NSString *)tsvfile{
    for(NSString *endstr in self.tsvfileNModuleDict){
        if([tsvfile hasSuffix:endstr]){
            return self.tsvfileNModuleDict[endstr];
        }
    }
    return nil;
}
@end
