


//
//  YFBaseConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2019/3/6.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFBaseConfig.h"

@implementation YFBaseConfig
-(instancetype)initWithOutputDir:(NSString *)outputDir{
    if(self = [super init]){
        self.outputDir = outputDir;
        [self initData];
    }
    return self;
}
-(instancetype)init{
    return [self initWithOutputDir:nil];
}

-(void)initData{
    
}

-(NSString *)fullOutputPath:(NSString *)subPath{
    return workingPath(iFormatStr(@"%@/%@",self.outputDir,subPath));
}


-(NSString *)outputDir{
    if(_outputDir)return iFormatStr(@"outputDir/%@",_outputDir);
    return @"outputDir";
}
@end
