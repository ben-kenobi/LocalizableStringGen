//
//  YFLovslTSVConvertConfig.m
//  LocalizableStringGen
//
//  Created by hui on 2018/11/25.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLovslTSVConvertConfig.h"

@implementation YFLovslTSVConvertConfig
-(instancetype)init{
    if(self = [super init]){
        //文件夹需要 / 结尾
        self.tsvDir=workingPath(@"tsvgenDir/");
        self.stringsDir=workingPath(@"stringsDir/");
        
        //根据tsv文件值的位置
        self.keyIdx=0;
        self.valIdx=5;


    }
    return self;
}
-(NSString *)destPathBySrcfile:(NSString *)path{
    BOOL isDir = NO;
    NSString *dir = self.tsvDir;
    if(self.revert)
        dir = self.stringsDir;
    
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    NSString *name = [path lastPathComponent].stringByDeletingPathExtension;
    NSString *ext = self.revert?@".strings":@".tsv";
    return iFormatStr(@"%@%@%@",dir,name,ext);
}
@end
