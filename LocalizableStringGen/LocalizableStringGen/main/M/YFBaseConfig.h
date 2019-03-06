//
//  YFBaseConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2019/3/6.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YFBaseConfig : NSObject
@property (nonatomic,strong)NSString *outputDir;
-(NSString *)fullOutputPath:(NSString *)subPath;
-(instancetype)initWithOutputDir:(NSString *)outputDir;


// overrid by subclass
-(void)initData;
@end


