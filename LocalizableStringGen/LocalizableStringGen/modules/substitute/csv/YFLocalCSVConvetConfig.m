
//
//  YFLocalCSVConvetConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalCSVConvetConfig.h"

@implementation YFLocalCSVConvetConfig
-(void)initData{
    //文件夹需要 / 结尾
    
    NSMutableArray *mary = [NSMutableArray array];
    BOOL isdir=NO;
    NSString *csvDir = workingPath(@"csvDir/");
    BOOL exist = [iFm fileExistsAtPath:csvDir isDirectory:&isdir];
    //    NSAssert(exist, @"-----dir not exists -----");
    //    NSAssert(isdir, @"----- not dir -----");
    NSArray *ary = [iFm subpathsAtPath:csvDir];
    for(NSString *file in ary){
        NSString *cdir = iFormatStr(@"%@%@",csvDir,file);
        BOOL isCsvDir = NO;
        [iFm fileExistsAtPath:cdir isDirectory:&isCsvDir];
        if(!isCsvDir) continue;
        [mary addObject:cdir];
    }
    self.csvDirs = mary;
    
    self.stringsDir=workingPath(@"stringsDir/");
    
    //根据tsv文件值的位置
    self.keyIdx=0;
    self.valIdx=1;
}
-(NSString *)destPathBySrcfile:(NSString *)path{
    BOOL isDir = NO;
    NSString *dir = workingPath(@"csvDir/");
    
    
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    NSString *name = [path lastPathComponent].stringByDeletingPathExtension;
    NSString *ext = @".csv";
    return iFormatStr(@"%@%@%@",dir,name,ext);
}


//csv - > strings
-(NSString *)stringDestPathBySrcfile:(NSString *)path dir:(NSString *)idir{
    NSString *tsvDirName = idir.lastPathComponent;
    BOOL isDir = NO;
    NSString *dir = [self fullOutputPath: iFormatStr(@"%@/%@",tsvDirName,@"stringsDir/")];
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    NSString *name = [path lastPathComponent].stringByDeletingPathExtension;
    NSString *ext = @".strings";
    return iFormatStr(@"%@%@%@",dir,name,ext);
}
@end
