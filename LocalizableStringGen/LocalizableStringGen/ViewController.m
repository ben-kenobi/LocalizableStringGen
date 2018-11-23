//
//  ViewController.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "ViewController.h"
#import "YFLocalizedHelper.h"
#import "YFUtil.h"

@interface ViewController ()
@property (nonatomic,strong)YFLocalizedHelper *helper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

}


#pragma mark - events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark - actions
-(void)start{
    [iPop showProg];
    self.helper=[YFLocalizedHelper startWithConfig:[[YFLocalizeConfig alloc]init] compCB:^{
        [iPop dismProg];
    }];
}


#pragma mark - UI
-(void)initUI{
    UIButton *btn = [IProUtil commonTextBtn:iFont(18) color:iGlobalFocusColor title:@"Start"];
    [UIUtil commonTexBtn:btn tar:self action:@selector(start)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.height.equalTo(@58);
        make.width.equalTo(@200);
    }];
    
}


@end
