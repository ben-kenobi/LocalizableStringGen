import pandas as pd

sys_usr = 'yf'
i18n_dir = f'/Users/{sys_usr}/Desktop/I18N'
eufy_security_file = pd.ExcelFile(f'{i18n_dir}/Eufy Security 翻译-190214.xlsx')
# 打印sheet名，复制需要的sheet名
print(eufy_security_file.sheet_names)



# 创建需要的sheet名string文件的关联关系
main_str_f = 'Localizable'
main_csv_fs = ['Common', '门锁-HomeBaseMini', 'homekit_ios', 'Floodlight',
               'Geofencing', 'repeater','Devices', 'Events',
               'DeviceSetting', 'Mode', 'Sdcard_Upgrade', 'DrawerSettings',
               'App_Special', 'Player', 'SmartDetection', 'Account', 'Bind',
               'CloudStorage', 'Family', 'AppReview', 'richStrings',
               'new_guide_page', 'Exception_HB2', 'other' ,'solo_camera','T8423','SmartDrop']

setting_str_f = 'BCCommonSettingPlist'
setting_csv_fs = ['Floodlight_SettingS','settings_ios']

push_str_f = 'BCBaseLocalizable'
push_csv_fs = ['push_ios']

info_str_f = 'InfoPlist'
info_csv_fs = ['ios_infoplist_ios']

menu_str_f = 'MenuListPlist'
menu_csv_fs = [ 'menu_tab']

file_tree = {
    main_str_f: main_csv_fs,
    setting_str_f: setting_csv_fs,
    push_str_f: push_csv_fs,
    info_str_f: info_csv_fs,
    menu_str_f: menu_csv_fs
}




# 遍历倒出成csv格式到指定目录
from pathlib import Path


def xls2csv_and_save(xlsfile, sheetname, dirname):
    csv_dir = f'{i18n_dir}/{dirname}'
    Path(csv_dir).mkdir(parents=True, exist_ok=True)
    csv_f = f'{csv_dir}/{sheetname}.csv'
    sheet_df = xlsfile.parse(sheetname)
    sheet_df.to_csv(csv_f,index=False,line_terminator='\r\n')


for dirname, sheets in file_tree.items():
    for sheetname in sheets:
        xls2csv_and_save(eufy_security_file, sheetname, f'csvDir/{dirname}')

