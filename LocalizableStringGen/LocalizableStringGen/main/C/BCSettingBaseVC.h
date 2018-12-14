//
//  BCSettingBaseVC.h
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCommonSettingCell.h"
@interface BCSettingBaseVC : UIViewController<UITableViewDelegate,UITableViewDataSource,BCCommonSettingCellDelegate>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,strong)Class cellClz;
@property (nonatomic,strong)NSMutableArray *datas;


-(void)clickAtIdxPath:(NSIndexPath *)idxpath;
-(void)setupCell:(BCCommonSettingCell *)cell idxpath:(NSIndexPath *)idxpath;
-(UITableViewCell *)dequeueCellFrom:(UITableView *)tv iden:(NSString *)iden idxpath:(NSIndexPath *)idxpath;

//export
-(id<BCCommonSettingMod>)modByIdxpath:(NSIndexPath *)idxpath;
-(NSString *)titleBy:(NSInteger)section;
-(NSString *)footerTitleBy:(NSInteger)section;
-(void)setLoading:(BOOL)loading at:(NSIndexPath *)idxpath;
-(void)commonLoadingSequenceAt:(NSIndexPath *)idxpath action:(void(^)(BOOL (^cb)(void)))action ;
@end
