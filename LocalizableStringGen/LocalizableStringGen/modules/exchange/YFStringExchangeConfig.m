
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
        self.srcLocalizedStringFile=workingPath(@"Localizable_dest.strings");
        self.destLocalizedStringFile=workingPath(@"Localizable_dest_exchanged.strings");
        self.multiOccuredDestLocalizedStringFile=workingPath(@"Localizable_multy.strings");

    }
    return self;
}
@end
