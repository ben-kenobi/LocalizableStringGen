//
//  YFStringsDiffConfig.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsDiffConfig.h"
@interface YFStringsDiffConfig()

@end

@implementation YFStringsDiffConfig


-(void)initData{
   
    self.ignoreKeyDict = iRes4dict(@"ignorKeys.plist");
    
    NSMutableArray *mary = [NSMutableArray array];
    BOOL isdir=NO;
    NSString *dir = workingPath(@"srcDir/");
    BOOL exist = [iFm fileExistsAtPath:dir isDirectory:&isdir];
    NSAssert(exist, @"-----dir not exists -----");
    NSAssert(isdir, @"----- not dir -----");
    NSArray *ary = [iFm subpathsAtPath:dir];
    for(NSString *file in ary){
        if([file hasSuffix:@".strings"])
            [mary addObject: iFormatStr(@"%@%@",dir,file)];
    }
        
    self.srcLocalizedStringFiles = mary;
}


-(NSString *)tarLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_merged.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}
-(NSString *)addedLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_new.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}
-(NSString *)deletedLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_delete.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}
-(NSString *)substitutedLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_update.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}
-(NSString *)unchangedLocalizedStringFileBy:(NSInteger)idx{
    
    NSString *path = iFormatStr(@"%@/strings_unchanged.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}
-(NSString *)noTranslatedLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_notranslated.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}

-(NSString *)ignoreLocalizedStringFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"%@/strings_ignore.strings",[[self.srcLocalizedStringFiles[idx] lastPathComponent] stringByDeletingPathExtension]);
    return [self fullOutputPath:path];
}

-(NSString *)destFileBy:(NSInteger)idx{
    NSString *path = iFormatStr(@"dest/%@",[self.srcLocalizedStringFiles[idx] lastPathComponent]);
    return [self fullOutputPath:path];
}
-(NSString *)destDir{
    return [self fullOutputPath:@"dest/"];
}

@end
