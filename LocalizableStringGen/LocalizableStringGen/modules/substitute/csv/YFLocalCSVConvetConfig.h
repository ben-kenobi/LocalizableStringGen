//
//  YFLocalCSVConvetConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/24.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLocalCSVConvetConfig : NSObject
@property (nonatomic,strong)NSString *stringsDir;
@property (nonatomic,strong)NSString *csvDir;
@property (nonatomic,assign)BOOL revert;//NO:string->csv,YES:csv->strings
-(NSString *)destPathBySrcfile:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
