

//
//  YFStringsMergeOrDisperseConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/27.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsMergeOrDisperseConfig.h"

@implementation YFStringsMergeOrDisperseConfig

-(void)initData{
    NSMutableArray *mary = [NSMutableArray array];
    BOOL isdir=NO;
    NSString *dispersedDir =[self fullOutputPath:@""];
    BOOL exist = [iFm fileExistsAtPath:dispersedDir isDirectory:&isdir];
    NSAssert(exist, @"-----dir not exists -----");
    NSAssert(isdir, @"----- not dir -----");
    NSArray *ary = [iFm subpathsAtPath:dispersedDir];
    for(NSString *file in ary){
        NSString *tdir = iFormatStr(@"%@%@/%@",dispersedDir,file,@"stringsDir/");
        BOOL isStrDir = NO;
        BOOL strDirExist = [iFm fileExistsAtPath:tdir isDirectory:&isStrDir];
        if(!strDirExist || !isStrDir) continue;
        [mary addObject:tdir];
    }
    self.dispersedStringsDirs=mary;

    self.mergedStringFile=workingPath(@"strings_merged_Localizable.strings");
}

-(NSString *)dispsersedPathByModule:(NSString *)module{
    NSString *dir = workingPath(@"stringsDir");
    BOOL isDir = NO;
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    
    return iFormatStr(@"%@%@.strings",dir,module);
}
-(NSString *)moduleByKey:(NSString *)stringKey{
    NSArray * arr = [stringKey componentsSeparatedByString:@"."];
    if(arr.count>2) return arr[1];
    return @"--undefined--";
}
@end
