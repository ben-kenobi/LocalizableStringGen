
//
//  YFLocalCSVConvetConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalCSVConvetConfig.h"

@implementation YFLocalCSVConvetConfig
-(instancetype)init{
    if(self = [super init]){
        //文件夹需要 / 结尾
        self.csvDir=@"/Users/yf/Desktop/cvsDir/";
        self.stringsDir=@"/Users/yf/Desktop/stringsDir/";
    }
    return self;
}
-(NSString *)destPathBySrcfile:(NSString *)path{
    BOOL isDir = NO;
    NSString *dir = self.csvDir;
    if(self.revert)
        dir = self.stringsDir;
    
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isDir];
    
    NSAssert(!exist||isDir, @"-----Not a directory-----");
    
    if(!exist){
        [iFm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:0];
    }
    NSString *name = [path lastPathComponent].stringByDeletingPathExtension;
    NSString *ext = self.revert?@".strings":@".csv";
    return iFormatStr(@"%@%@%@",dir,name,ext);
}
@end
