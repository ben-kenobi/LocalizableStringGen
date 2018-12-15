//
//  YFStringsUtilVC.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/13.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsUtilVC.h"
#import "BCCameraSettingCell.h"
#import "YFLocalizedHelper.h"
#import "YFLocalGroupHelper.h"
#import "YFUtil.h"
#import "YFLocalGroup2Helper.h"
#import "YFLocalCSVConvertHelper.h"
#import "YFLocalTSVConvertHelper.h"
#import "YFStringsExchangeHelper.h"
#import "YFStringMergeNDisperseHelper.h"
#import "YFStringsDiffHelper.h"
#import "YFStringUpdateHelper.h"

@interface YFStringsUtilVC ()
@property (nonatomic,strong)id helper;
@end

@implementation YFStringsUtilVC

- (void)viewDidLoad {
    self.cellClz = BCCameraSettingCell.class;
    [super viewDidLoad];
    [self initUI];
    [self updateData];
    
}
-(void)updateData{
    
}



#pragma mark - actions
-(void)gen:(NSIndexPath *)idxpath{
    [iPop showProg];
    self.helper=[YFLocalizedHelper startWithConfig:[[YFLocalizeConfig alloc]init] gen:YES compCB:^{
        [iPop dismProg];
    }];
}
-(void)replace:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFLocalizeConfig *config = [[YFLocalizeConfig alloc]init];
    config.revertReplace=[self modByIdxpath:idxpath].on;
    self.helper=[YFLocalizedHelper startWithConfig:config gen:NO compCB:^{
        [iPop dismProg];
    }];
}
-(void)groupFromTSV:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFLocalGroupConfig *config = [[YFLocalGroupConfig alloc]init];
    
    self.helper=[YFLocalGroupHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)groupFromProject:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFLocalGroup2Config *config = [[YFLocalGroup2Config alloc]init];
    config.diposeConflict=[self modByIdxpath:idxpath].on;
    config.onlyKeepStringsExistInStringsFile=YES;//是否只处理存在于.strings文件中的串
    self.helper=[YFLocalGroup2Helper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)cvsConvert:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFLocalCSVConvetConfig *config = [[YFLocalCSVConvetConfig alloc]init];
    config.revert=[self modByIdxpath:idxpath].on;
    self.helper=[YFLocalCSVConvertHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}

-(void)tsvConvert:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFLovslTSVConvertConfig *config = [[YFLovslTSVConvertConfig alloc]init];
    config.revert=[self modByIdxpath:idxpath].on;
    
    self.helper=[YFLocalTSVConvertHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)exchange:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFStringExchangeConfig *config = [[YFStringExchangeConfig alloc]init];
    
    self.helper=[YFStringsExchangeHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)mergeOrdisperse:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFStringsMergeOrDisperseConfig *config = [[YFStringsMergeOrDisperseConfig alloc]init];
    config.reverse=[self modByIdxpath:idxpath].on;
    self.helper=[YFStringMergeNDisperseHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)diffStrings:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFStringsDiffConfig *config = [[YFStringsDiffConfig alloc]init];
    self.helper=[YFStringsDiffHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
-(void)updateStringsByStrings:(NSIndexPath *)idxpath{
    [iPop showProg];
    YFStringsUpddateConfig *config = [[YFStringsUpddateConfig alloc]init];
    self.helper=[YFStringUpdateHelper startWithConfig:config compCB:^{
        [iPop dismProg];
    }];
}
#pragma mark - UI
-(void)initUI{
    self.tv.rowHeight=dp2po(70);
}

@end
