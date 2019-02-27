//
//  YFTimezoneListConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2019/2/27.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFTimezoneListConfig : NSObject
@property (nonatomic,strong)NSString *srcPlist;//原始文件
@property (nonatomic,strong)NSString *destPlist;//新文件
@property (nonatomic,strong)NSString *substituteStrings;//新文案所在文件
@end

NS_ASSUME_NONNULL_END
