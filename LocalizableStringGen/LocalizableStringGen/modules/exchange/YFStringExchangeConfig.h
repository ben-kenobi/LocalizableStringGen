//
//  YFStringExchangeConfig.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/26.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFStringExchangeConfig : NSObject
@property (nonatomic,strong)NSString *srcLocalizedStringFile;
@property (nonatomic,strong)NSString *destLocalizedStringFile;
@end

NS_ASSUME_NONNULL_END
