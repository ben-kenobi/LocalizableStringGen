

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
        self.groupCSVDir=@"/Users/yf/Desktop/cvsgroup/";
        self.fileExts=@[@".csv"];
        self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable.strings";
        self.leftLocalizedStringFile=@"/Users/yf/Desktop/Localizable_left.strings";
    }
    return self;
}
@end
