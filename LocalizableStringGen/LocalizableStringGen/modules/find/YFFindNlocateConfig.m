
//
//  YFFindNlocateConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFFindNlocateConfig.h"

@implementation YFFindNlocateConfig
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
    }
    return self;
}

@end
