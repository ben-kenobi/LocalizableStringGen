

//
//  YFTimezoneListConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2019/2/27.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFTimezoneListConfig.h"

@implementation YFTimezoneListConfig
-(instancetype)init{
    if(self = [super init]){
        [self defSetting];
    }
    return self;
}

-(void)defSetting{
    self.srcPlist=workingPath(@"hub_timezones.plist");
    self.destPlist=workingPath(@"hub_timezones_dest.plist");
    self.substituteStrings=workingPath(@"timezones.strings");
}
@end
