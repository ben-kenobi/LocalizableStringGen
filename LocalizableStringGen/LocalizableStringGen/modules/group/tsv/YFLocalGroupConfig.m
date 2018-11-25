

//
//  YFLocalGroupConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalGroupConfig.h"

@implementation YFLocalGroupConfig
-(instancetype)init{
    if(self = [super init]){
        //文件夹需要 / 结尾
        self.groupTSVDir=@"/Users/hui/Desktop/tsvGroup/";
        self.fileExts=@[@".tsv"];
        self.srcLocalizedStringFile=@"/Users/hui/Desktop/Localizable.strings";
        self.leftLocalizedStringFile=@"/Users/hui/Desktop/Localizable_left.strings";
        
        self.keyIdx=0;
        self.valIdx=1;
    }
    return self;
}
@end
