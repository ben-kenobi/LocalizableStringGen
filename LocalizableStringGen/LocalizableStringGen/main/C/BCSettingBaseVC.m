
//
//  BCSettingBaseVC.m
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCSettingBaseVC.h"
#import "BCCommonTvModel.h"
#import "BCCameraSettingMod.h"

static NSString *celliden = @"celliden";
@interface BCSettingBaseVC ()


@end


@implementation
BCSettingBaseVC


-(BOOL)outofBounds:(NSInteger)sec{
    return sec>=self.datas.count;
}

-(void)loadBaseData{
    NSArray *arys = iRes4ary(_pname);
    for(id obj in arys){
        BOOL isAry = [obj isKindOfClass:NSArray.class];
        if(!isAry){
            [self.datas addObject:[BCCommonTvModel setDict:(NSDictionary*)obj]];
        }else{
            NSMutableArray *mary = [NSMutableArray array];
            [self.datas addObject:mary];
            for(NSDictionary *dict in (NSArray *)obj){
                [mary addObject:[BCCameraSettingMod setDict:dict]];
            }
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.pname = iFormatStr(@"%@.plist",NSStringFromClass(self.class));
    [self initBaseUI];
    [self loadBaseData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tv reloadData];
}



-(void)setupCell:(BCCommonSettingCell *)cell idxpath:(NSIndexPath *)idxpath{
    id<BCCommonSettingMod> mod=[self modByIdxpath:idxpath];
    cell.mod=mod;
}

iLazy4Ary(datas, _datas)

-(void)clickAtIdxPath:(NSIndexPath *)idxpath{
    
    id<BCCommonSettingMod> mod = [self modByIdxpath:idxpath];
    if(mod.method&&!mod.switchView){
        if([self respondsToSelector:NSSelectorFromString(mod.method)]){
            [self performSelector:NSSelectorFromString(mod.method) withObject:idxpath];
        }
    }else if(mod.vc){
        UIViewController *vc=[[NSClassFromString(mod.vc) alloc]init];
        vc.title=mod.title;
        [UIViewController pushVC:vc];
    }
    
}

#pragma mark - exported
-(NSString *)titleBy:(NSInteger)section{
    if([self outofBounds:section])return nil;
    if([self.datas[section] isKindOfClass:BCCommonTvModel.class]){
        NSString *str= ((BCCommonTvModel*)self.datas[section]).title;
        if(str)
            return NSLocalizedStringFromTable(str, @"BCCommonSettingPlist", nil);
    }
    return nil;
}
-(NSString *)footerTitleBy:(NSInteger)section{
    if([self outofBounds:section])return nil;
    if([self.datas[section] isKindOfClass:BCCommonTvModel.class]){
        NSString *str= ((BCCommonTvModel*)self.datas[section]).footerTitle;
        if(str)
            return NSLocalizedStringFromTable(str, @"BCCommonSettingPlist", nil);
    }
    return nil;
}
-(id<BCCommonSettingMod>) modByIdxpath:(NSIndexPath *)idxpath{
    if([self outofBounds:idxpath.section])return nil;
    NSArray *tmp = self.datas[idxpath.section];
    if(idxpath.row>tmp.count-1) return nil;
    
    return [tmp objectAtIndex:idxpath.row];
}


-(void)setLoading:(BOOL)loading at:(NSIndexPath *)idxpath{
    if(!idxpath)return;
    [self modByIdxpath:idxpath].loading=loading;
    if(idxpath.section<[self numberOfSectionsInTableView:self.tv]&&idxpath.row<[self tableView:self.tv numberOfRowsInSection:idxpath.section])
        [self.tv reloadRowsAtIndexPaths:@[idxpath] withRowAnimation:0];
}
-(void)commonLoadingSequenceAt:(NSIndexPath *)idxpath action:(void(^)(BOOL (^cb)(void)))action {
    [self setLoading:YES at:idxpath];
    @weakRef(self)
    action(^{
        if(!weak_self)return NO;
        [weak_self setLoading:NO at:idxpath];
        return YES;
    });
}



#pragma mark - BCCommonSettingCellDelegate
-(void)onSwitchChange:(BCCommonSettingCell *)cell{
    NSIndexPath *idxpath = [self.tv indexPathForCell:cell];
    id<BCCommonSettingMod> mod = [self modByIdxpath:idxpath];
    mod.on=cell.swi.on;
    if(mod.method){
        if([self respondsToSelector:NSSelectorFromString(mod.method)]){
            [self performSelector:NSSelectorFromString(mod.method) withObject:idxpath];
        }
    }
}

-(void)onEditClicked:(BCCommonSettingCell *)cell{
    NSIndexPath *idxpath = [self.tv indexPathForCell:cell];
    id<BCCommonSettingMod> mod = [self modByIdxpath:idxpath];
    if(mod.editMethod){
        if([self respondsToSelector:NSSelectorFromString(mod.editMethod)]){
            [self performSelector:NSSelectorFromString(mod.editMethod) withObject:idxpath];
        }
    }
}
#pragma mark - UITableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datas[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self dequeueCellFrom:tableView iden:celliden idxpath:indexPath];
}
-(UITableViewCell *)dequeueCellFrom:(UITableView *)tv iden:(NSString *)iden idxpath:(NSIndexPath *)idxpath{
    BCCommonSettingCell *cell = [tv dequeueReusableCellWithIdentifier:iden];
    [self setupCell:cell idxpath:idxpath];
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clickAtIdxPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self titleBy:section]){
        return dp2po(50);
    }
    return section==0?CGFLOAT_MIN:dp2po(10);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *fstr=[self footerTitleBy:section];
    if(fstr){
        CGSize size = [fstr sizeBy:CGSizeMake(iScreenW-30, CGFLOAT_MAX) font:iFont(14)];
        return size.height+20;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = [self titleBy:section];
    if(title){
        UIView *view=[[UIView alloc]init];
        UILabel *lab = [IProUtil commonLab:iFont(16) color:iColor(0x66, 0x66, 0x66, 1)];
        lab.text=title;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.bottom.equalTo(@(dp2po(-10)));
        }];
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *fstr=[self footerTitleBy:section];
    if(fstr){
        UIView *view=[[UIView alloc]init];
        UILabel *lab = [IProUtil commonLab:iFont(14) color:iColor(0x99, 0x99, 0x99, 1)];
        lab.numberOfLines=0;
        lab.text=fstr;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.trailing.equalTo(@-15);
            make.top.equalTo(@10);
        }];
        return view;
    }
    return nil;
}


#pragma mark - UI

-(void)initBaseUI{
    self.view.backgroundColor=iGlobalBG;
    self.tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tv.backgroundColor=iGlobalBG;
    self.tv.bounces=NO;
    self.tv.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tv.separatorColor=iCommonSeparatorColor;
    self.tv.separatorInset=UIEdgeInsetsMake(0, dp2po(15), 0, 0);
    self.tv.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, dp2po(0))];
    self.tv.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, 12)];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    self.tv.rowHeight=dp2po(48);
    [self.tv registerClass:self.cellClz forCellReuseIdentifier:celliden];
    [self.view addSubview:self.tv];
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tv.sectionHeaderHeight=0;
    self.tv.sectionFooterHeight=0;
}
-(Class)cellClz{
    if(!_cellClz){
        return BCCommonSettingCell.class;
    }
    return _cellClz;
}


@end
