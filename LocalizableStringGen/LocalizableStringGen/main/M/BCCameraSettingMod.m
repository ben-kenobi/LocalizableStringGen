//
//  BCCameraSettingMod.m
//  BatteryCam
//
//  Created by yf on 2017/8/20.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCameraSettingMod.h"

@implementation BCCameraSettingMod

-(void)setOn:(BOOL)on{
    _on=on;
    if(self.switchView&&self.hasEdit){
        self.editable=_on;
    }
}
@end
