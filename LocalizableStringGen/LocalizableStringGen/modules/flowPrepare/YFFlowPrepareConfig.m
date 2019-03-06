//
//  YFFlowPrepareConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2019/3/6.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFFlowPrepareConfig.h"

@implementation YFFlowPrepareConfig
-(void)prepare{
    BOOL isdir=NO;
    NSString *dir = workingPath(@"srcDir/");
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----dir not exists -----");
    NSAssert(isdir, @"----- not dir -----");
    NSArray *ary = [iFm subpathsAtPath:dir];
    for(NSString *file in ary){
        if(![file hasSuffix:@".strings"]) continue;
        NSString *name = [[file lastPathComponent] stringByDeletingPathExtension];
        [iFm createDirectoryAtPath:workingPath(iFormatStr(@"tsvDir/%@/",name)) withIntermediateDirectories:YES attributes:0 error:0];
    }
    
}
@end
