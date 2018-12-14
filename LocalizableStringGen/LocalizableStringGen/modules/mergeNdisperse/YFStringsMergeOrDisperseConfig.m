

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
        self.dispersedStringDir=workingPath(@"key_adjusted_strings/");
        self.mergedStringFile=workingPath(@"key_adjusted_strings_merged.strings");
    }
    return self;
}

-(NSString *)dispsersedPathByModule:(NSString *)module{
    BOOL isDir = NO;
    BOOL exist = [iFm fileExistsAtPath:self.dispersedStringDir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:self.dispersedStringDir withIntermediateDirectories:YES attributes:0 error:0];
    }
    
    return iFormatStr(@"%@%@.strings",self.dispersedStringDir,module);
}
-(NSString *)moduleByKey:(NSString *)stringKey{
    NSArray * arr = [stringKey componentsSeparatedByString:@"."];
    if(arr.count>2) return arr[1];
    return @"--undefined--";
}
@end
