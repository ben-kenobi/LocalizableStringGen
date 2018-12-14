//
//  BCCommonTvModel.m
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCommonTvModel.h"
#import "BCCommonSettingCell.h"
#import "BCCameraSettingMod.h"
@implementation BCCommonTvModel


-(void)setDatas:(NSArray *)datas{
     _datas = [NSMutableArray arrayWithCapacity:datas.count];
    for(NSDictionary *dict in datas){
        [_datas addObject:[BCCameraSettingMod setDict:dict]];
    }
}

-(NSInteger)count{
    return self.datas.count;
}
-(BCCameraSettingMod *)objectAtIndex:(NSInteger)idx{
    if(idx<0||idx>self.count-1) return nil;
    return self.datas[idx];
}

@end
