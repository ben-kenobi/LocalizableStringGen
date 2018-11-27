//
//  ViewController.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "ViewController.h"
#import "YFLocalizedHelper.h"
#import "YFLocalGroupHelper.h"
#import "YFUtil.h"
#import "YFLocalGroup2Helper.h"
#import "YFLocalCSVConvertHelper.h"
#import "YFLocalTSVConvertHelper.h"
#import "YFStringsExchangeHelper.h"
#import "YFStringMergeNDisperseHelper.h"

@interface ViewController ()
@property (nonatomic,strong)id helper;
@property (nonatomic,strong)UISwitch *conflictSiwtch;
@property (nonatomic,strong)UISwitch *strToCSVSiwtch;
@property (nonatomic,strong)UISwitch *revertReplaceSwitch;
@property (nonatomic,strong)UISwitch *strToTSVSwitch;
@property (nonatomic,strong)UISwitch *mergeOrdisperseSwitch;
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
-(void)gen{
    [iPop showProg];
    self.helper=[YFLocalizedHelper startWithConfig:[[YFLocalizeConfig alloc]init] gen:YES compCB:^{
        [iPop dismProg];
    }];
}
-(void)replace{
    [iPop showProg];
    YFLocalizeConfig *config = [[YFLocalizeConfig alloc]init];
    config.revertReplace=self.revertReplaceSwitch.on;
    self.helper=[YFLocalizedHelper startWithConfig:config gen:NO compCB:^{
        [iPop dismProg];
    }];
}
-(void)groupFromTSV{
    [iPop showProg];
    YFLocalGroupConfig *config = [[YFLocalGroupConfig alloc]init];
    //根据tsv文件值的位置
    config.keyIdx=0;
    config.valIdx=2;
    self.helper=[YFLocalGroupHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)groupFromProject{
    [iPop showProg];
    YFLocalGroup2Config *config = [[YFLocalGroup2Config alloc]init];
    config.diposeConflict=self.conflictSiwtch.on;
    config.onlyKeepStringsExistInStringsFile=YES;//是否只处理存在于.strings文件中的串
    self.helper=[YFLocalGroup2Helper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)convet{
    [iPop showProg];
    YFLocalCSVConvetConfig *config = [[YFLocalCSVConvetConfig alloc]init];
    config.revert=self.strToCSVSiwtch.on;
    self.helper=[YFLocalCSVConvertHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)tsvConvert{
    [iPop showProg];
    YFLovslTSVConvertConfig *config = [[YFLovslTSVConvertConfig alloc]init];
    config.revert=self.strToTSVSwitch.on;
    
    //根据tsv文件值的位置
    config.keyIdx=0;
    config.valIdx=2;
    
    self.helper=[YFLocalTSVConvertHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)exchange{
    [iPop showProg];
    YFStringExchangeConfig *config = [[YFStringExchangeConfig alloc]init];
    
    self.helper=[YFStringsExchangeHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)mergeOrdisperse{
    [iPop showProg];
    YFStringsMergeOrDisperseConfig *config = [[YFStringsMergeOrDisperseConfig alloc]init];
    config.reverse=self.mergeOrdisperseSwitch.on;
    self.helper=[YFStringMergeNDisperseHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

#pragma mark - UI
-(void)initUI{
    UIButton *genbtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Gen"];
    [UIUtil commonTexBtn:genbtn tar:self action:@selector(gen)];
    
    
    UIButton *replaceBtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Replace"];
    [UIUtil commonTexBtn:replaceBtn tar:self action:@selector(replace)];
    
    UIButton *groupBtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Group TSV"];
    [UIUtil commonTexBtn:groupBtn tar:self action:@selector(groupFromTSV)];
    UIButton *groupBtn2 = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Group Project"];
    [UIUtil commonTexBtn:groupBtn2 tar:self action:@selector(groupFromProject)];
    
    UIButton *csvbtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Strings->CSV"];
    [UIUtil commonTexBtn:csvbtn tar:self action:@selector(convet)];
    
    UIButton *tsvbtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"Strings->TSV"];
    [UIUtil commonTexBtn:tsvbtn tar:self action:@selector(tsvConvert)];
    
    
    UIButton *exchangebtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"StringsExchange"];
    [UIUtil commonTexBtn:exchangebtn tar:self action:@selector(exchange)];
    
    UIButton *mergeOrDispersebtn = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1) title:@"MergeOrDisperse"];
    [UIUtil commonTexBtn:mergeOrDispersebtn tar:self action:@selector(mergeOrdisperse)];
    
    self.conflictSiwtch=[[UISwitch alloc]init];
    
    self.strToCSVSiwtch=[[UISwitch alloc]init];
    
    self.revertReplaceSwitch=[[UISwitch alloc]init];
    
    self.strToTSVSwitch=[[UISwitch alloc]init];
    
    self.mergeOrdisperseSwitch=[[UISwitch alloc]init];
    
    //---layout ----
    
    [self.view addSubview:groupBtn];
    [self.view addSubview:groupBtn2];
    [self.view addSubview:csvbtn];
    [self.view addSubview:genbtn];
    [self.view addSubview:replaceBtn];
    [self.view addSubview:exchangebtn];
    [self.view addSubview:self.conflictSiwtch];
    [self.view addSubview:self.strToCSVSiwtch];
    [self.view addSubview:self.revertReplaceSwitch];
    [self.view addSubview:tsvbtn];
    [self.view addSubview:self.strToTSVSwitch];
    [self.view addSubview:mergeOrDispersebtn];
    [self.view addSubview:self.mergeOrdisperseSwitch];
    CGFloat gap=30;
    [genbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.centerX.equalTo(@0);
        make.height.equalTo(@58);
        make.width.equalTo(@200);
    }];
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genbtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [self.revertReplaceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(replaceBtn);
        make.leading.equalTo(replaceBtn.mas_trailing).offset(15);
    }];
    [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(replaceBtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [groupBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupBtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [self.conflictSiwtch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(groupBtn2);
        make.leading.equalTo(groupBtn2.mas_trailing).offset(15);
    }];
    
    [csvbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupBtn2.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [self.strToCSVSiwtch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(csvbtn);
        make.leading.equalTo(csvbtn.mas_trailing).offset(15);
    }];
    
    [tsvbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(csvbtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [self.strToTSVSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tsvbtn);
        make.leading.equalTo(tsvbtn.mas_trailing).offset(15);
    }];
    [exchangebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tsvbtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
   
    
    [mergeOrDispersebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exchangebtn.mas_bottom).offset(gap);
        make.height.width.centerX.equalTo(genbtn);
    }];
    [self.mergeOrdisperseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mergeOrDispersebtn);
        make.leading.equalTo(tsvbtn.mas_trailing).offset(15);
    }];
    
}


@end
