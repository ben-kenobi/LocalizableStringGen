

//
//  YFStringsMergeOrDisperseConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/27.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsMergeOrDisperseConfig.h"

@implementation YFStringsMergeOrDisperseConfig
-(instancetype)init{
    if(self = [super init]){
        self.dispersedStringDir=@"/Users/yf/Desktop/key_adjusted_strings/";
        self.mergedStringFile=@"/Users/yf/Desktop/key_adjusted_strings_merged.strings";
    }
    return self;
}
@end
