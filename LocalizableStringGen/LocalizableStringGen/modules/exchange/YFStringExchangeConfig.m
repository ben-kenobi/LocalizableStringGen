
//
//  YFStringExchangeConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/26.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringExchangeConfig.h"

@implementation YFStringExchangeConfig
-(instancetype)init{
    if(self = [super init]){
        self.srcLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest.strings";
        self.destLocalizedStringFile=@"/Users/yf/Desktop/Localizable_dest_exchanged.strings";
    }
    return self;
}
@end
