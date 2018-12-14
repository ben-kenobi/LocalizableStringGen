//
//  BCCameraSettingCell.m
//  BatteryCam
//
//  Created by yf on 2017/8/20.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCameraSettingCell.h"



@interface BCCameraSettingCell ()

@end


@implementation BCCameraSettingCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]){
    }
    return self;
}
-(void)initUI{
    [super initUI];
    self.detailTextLabel.numberOfLines=0;
}

-(void)setMod:(id<BCCommonSettingMod>)mod{
    [super setMod:mod];
}
@end
