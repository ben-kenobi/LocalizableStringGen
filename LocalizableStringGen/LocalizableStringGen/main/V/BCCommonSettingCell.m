//
//  BCCommonSettingCell.m
//  BatteryCam
//
//  Created by yf on 2017/8/22.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCommonSettingCell.h"
static CGFloat cellh=44;
@implementation BCCommonSettingCell


-(void)setMod:(id<BCCommonSettingMod>)mod{
    _mod=mod;
    [self.disabledCover removeFromSuperview];
    self.swi.enabled=YES;
    self.textLabel.text=NSLocalizedStringFromTable(mod.title, @"BCCommonSettingPlist", nil);
    self.detailTextLabel.text=NSLocalizedStringFromTable(mod.detail, @"BCCommonSettingPlist", nil);
    self.accessoryView=nil;
    self.accessoryType=0;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    if(mod.loading){
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [act startAnimating];
        self.accessoryView=act;
    }else if(mod.switchView&&mod.hasEdit){
        self.swi.on=mod.on;
        self.editBtn.enabled=mod.editable;
        self.accessoryView=[self editableSwitchView];
    }else if(mod.switchView){
        [self.swi removeFromSuperview];
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.swi.w, cellh)];
        [v addSubview:self.swi];
        [self.swi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        self.accessoryView=v;
        self.swi.on=mod.on;
    }else if(mod.hasEdit){
        [self.editBtn removeFromSuperview];
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [v addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        self.accessoryView=v;
        self.editBtn.enabled=mod.editable;
    }else if(mod.selectMod){
        if(mod.selected)
        self.accessoryType=UITableViewCellAccessoryCheckmark;
        self.selectionStyle=UITableViewCellSelectionStyleDefault;

    }else if(mod.hasDetail){
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle=UITableViewCellSelectionStyleDefault;
    }
    self.iconIv.hidden=YES;
    if([mod.icon isKindOfClass:NSString.class]){
        self.iconIv.hidden=emptyStr(mod.icon);
        self.iconIv.image=img(mod.icon);
        [self.iconIv sizeToFit];
        self.accessoryView=self.iconIv.hidden?nil:self.iconIv;
    }else if([mod.icon isKindOfClass:UIImage.class]){
        self.iconIv.hidden=!mod.icon;
        self.iconIv.image=mod.icon;
        [self.iconIv sizeToFit];
        self.accessoryView=self.iconIv.hidden?nil:self.iconIv;
    }
    self.imageView.image=nil;
    if([mod.img isKindOfClass:NSString.class]){
        self.imageView.image=img(mod.img);
    }else if([mod.img isKindOfClass:UIImage.class]){
        self.imageView.image=mod.img;
    }
    if(mod.disabled){
        [self addSubview:self.disabledCover];
        [self bringSubviewToFront:self.disabledCover];
        [self.disabledCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        self.swi.enabled=NO;
    }
}

-(void)onSwitchChange:(UISwitch *)sender{
    self.mod.on=sender.on;
    [self.delegate onSwitchChange:self];
}
-(void)edit:(UIButton *)sender{
    [self.delegate onEditClicked:self];
}

#pragma mark - UI
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style == UITableViewCellStyleDefault ? UITableViewCellStyleValue1:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}


-(void)initUI{
    self.selectedBackgroundView=[[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor=iGlobalBG;
    self.textLabel.textColor=iColor(0x22, 0x22, 0x22, 1);
    self.textLabel.font=iFont(15);
    self.detailTextLabel.textColor=iColor(0xbb, 0xbb, 0xbb, 1);
    self.detailTextLabel.font=iFont(12);
}

-(UILabel *)cancelLabel{
    if (!_cancelLabel) {
        _cancelLabel=[[UILabel alloc] init];
        _cancelLabel.font=iFont(17);
        _cancelLabel.textAlignment=NSTextAlignmentCenter;
        _cancelLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:_cancelLabel];
        [_cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }
    return _cancelLabel;
}

-(UIImageView *)iconIv{
    if(!_iconIv){
        _iconIv=[[UIImageView alloc]init];
//        [self.contentView addSubview:_iconIv];
//        [_iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(@0);
//            make.trailing.equalTo(@(dp2po(-18)));
//        }];
    }
    return _iconIv;
}
-(UIButton *)editBtn{
    if(!_editBtn){
        _editBtn=[[UIButton alloc]init];
        [_editBtn setImage:img(@"icons8-go-filled-90") forState:0];
        [_editBtn setImage:[img(@"icons8-go-filled-90") renderWithColor:iColor(0xaa, 0xaa, 0xaa, 1)] forState:UIControlStateDisabled];
        _editBtn.imageView.contentMode=UIViewContentModeCenter;
        _editBtn.size=CGSizeMake(cellh, cellh);
        _editBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
        [_editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
-(UISwitch *)swi{
    if(!_swi){
        _swi=[[UISwitch alloc]init];
        _swi.onTintColor=iSwitchTint;
        [_swi addTarget:self action:@selector(onSwitchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _swi;
}
-(UIButton*)disabledCover{
    if(!_disabledCover){
        _disabledCover=[[UIButton alloc]init];
        [_disabledCover setBackgroundColor:iColor(0xff, 0xff, 0xff, .6)];
    }
    return _disabledCover;
}

-(UIView *)editableSwitchView{
    CGFloat h=cellh;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 92, h)];
    [self.swi removeFromSuperview];
    [self.editBtn removeFromSuperview];
    [view addSubview:self.swi];
    [view addSubview:self.editBtn];
    
    [self.swi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(@0);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(@0);
    }];
    return view;
}

@end
