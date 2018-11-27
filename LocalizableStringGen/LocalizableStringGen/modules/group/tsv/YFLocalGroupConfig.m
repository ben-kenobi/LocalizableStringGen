

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
        self.groupTSVDir=@"/Users/yf/Desktop/tsvGroup/";
        self.fileExts=@[@".tsv"];
        self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable.strings";
        self.leftLocalizedStringFile=@"/Users/yf/Desktop/Localizable_left.strings";
        self.matchedLocalizedStringFile=@"/Users/yf/Desktop/Localizable_matched.strings";
        
        self.keyIdx=0;
        self.valIdx=1;
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
