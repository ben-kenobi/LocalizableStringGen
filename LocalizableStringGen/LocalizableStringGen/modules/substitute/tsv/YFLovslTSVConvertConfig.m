//
//  YFLovslTSVConvertConfig.m
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLovslTSVConvertConfig.h"

@implementation YFLovslTSVConvertConfig
-(void)initData{
    //文件夹需要 / 结尾
    
    NSMutableArray *mary = [NSMutableArray array];
    BOOL isdir=NO;
    NSString *tsvDir = workingPath(@"tsvDir/");
    BOOL exist = [iFm fileExistsAtPath:tsvDir isDirectory:&isdir];
    NSAssert(exist, @"-----dir not exists -----");
    NSAssert(isdir, @"----- not dir -----");
    NSArray *ary = [iFm subpathsAtPath:tsvDir];
    for(NSString *file in ary){
        NSString *tdir = iFormatStr(@"%@%@",tsvDir,file);
        BOOL isTsvDir = NO;
        [iFm fileExistsAtPath:tdir isDirectory:&isTsvDir];
        if(!isTsvDir) continue;
        [mary addObject:tdir];
    }
    self.tsvDirs = mary;
    
    self.stringsDir=workingPath(@"stringsDir/");
    
    //根据tsv文件值的位置
    self.keyIdx=0;
    self.valIdx=2;
}

//tsv - > strings
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
//string - > tsv
-(NSString *)tsvDestPathBySrcfile:(NSString *)path{
    BOOL isDir = NO;
    NSString *dir = workingPath(@"tsvDir/");
   
    
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    NSString *name = [path lastPathComponent].stringByDeletingPathExtension;
    NSString *ext = @".tsv";
    return iFormatStr(@"%@%@%@",dir,name,ext);
}
@end
