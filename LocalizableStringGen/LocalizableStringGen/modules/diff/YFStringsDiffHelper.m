

//
//  YFStringsDiffHelper.m
//  LocalizableStringGen
//
//  Created by yf on 2018/12/14.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFStringsDiffHelper.h"
#import "YFStringMergeNDisperseHelper.h"

@interface YFStringsDiffHelper()
@property (nonatomic,strong)YFStringsDiffConfig *config;
@property (nonatomic,copy)void(^compCB)(void);

@end
@implementation YFStringsDiffHelper
+(instancetype)startWithConfig:(YFStringsDiffConfig *)config compCB:(void(^)(void))compCB{
    YFStringsDiffHelper *helper = [[YFStringsDiffHelper alloc]init];
    helper.config=config;
    helper.compCB = compCB;
    [helper start];
    return helper;
}
-(void)start{
    runOnGlobal(^{
        [self diff];
        runOnMain(^{
            if(self.compCB)
                self.compCB();
        });
    });
}

#pragma mark - actions

-(void)diff{
    for(int i=0;i<self.config.srcLocalizedStringFiles.count;i++){
        NSMutableDictionary *srcLocalizedDict=[YFLocalizeUtil localStringDictFrom:self.config.srcLocalizedStringFiles[i]];
        
        NSMutableDictionary *tarLocalizedDict=[YFLocalizeUtil localStringDictFrom:[self.config tarLocalizedStringFileBy:i]];
        
        NSMutableString *unchangeMstr = [NSMutableString string];
        NSMutableString *addedMstr = [NSMutableString string];
        NSMutableString *updatedMstr = [NSMutableString string];
        NSMutableString *notransMstr = [NSMutableString string];
        NSMutableString *ignoreMstr = [NSMutableString string];
        NSMutableDictionary *deleteLocalizedDict=[NSMutableDictionary dictionaryWithDictionary:srcLocalizedDict];
        [deleteLocalizedDict removeObjectsForKeys:tarLocalizedDict.allKeys];
        
        for(NSString *key in tarLocalizedDict.allKeys){
            NSString *srcVal = srcLocalizedDict[key];
            NSString *tarval = tarLocalizedDict[key];
            if(srcVal){
                if([srcVal isEqualToString:tarval]){
                    [YFLocalizeUtil append:unchangeMstr key:key val:srcVal];
                }else if(!emptyStr(tarval)){
                    [YFLocalizeUtil append:updatedMstr key:key val:tarval];
                }else{
                    [YFLocalizeUtil append:notransMstr key:key val:srcVal];
                }
            }else{
                //如果是新增字串，却被忽略了，则不新增
                if(self.config.ignoreKeyDict[key] == nil)
                    [YFLocalizeUtil append:addedMstr key:key val:tarval];
                
            }
        }
        NSDictionary *delDictCopy = [NSDictionary dictionaryWithDictionary:deleteLocalizedDict];
        for(NSString *key in delDictCopy.allKeys){
            NSString *srcVal = delDictCopy[key];
            if(self.config.ignoreKeyDict[key]){
                [deleteLocalizedDict removeObjectForKey:key];
                [YFLocalizeUtil append:ignoreMstr key:key val:srcVal];
            }
            
        }
        
        
        // export
        
        NSMutableString *deleteMstr = [NSMutableString string];
        for(NSString *key in deleteLocalizedDict.allKeys){
            NSString *val = deleteLocalizedDict[key];
            [YFLocalizeUtil append:deleteMstr key:key val:val];
        }
        
        
        NSString *mergedStr = iFormatStr(@"%@\n\n//updated\n%@\n\n//ignored\n%@\n\n//notrans\n%@\n\n//added\n%@\n\n//deleted\n%@\n",unchangeMstr,updatedMstr,ignoreMstr,notransMstr,addedMstr,deleteMstr);
        NSString *destFile = [self.config destFileBy:i];
        if(![iFm fileExistsAtPath:destFile]){
            [iFm createDirectoryAtPath:destFile.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [mergedStr writeToFile:[self.config destFileBy:i] atomically:YES encoding:4 error:0];
        if(self.config.onlyExportMerged) continue;
        
        
        if(!emptyStr(deleteMstr))
            [deleteMstr writeToFile:[self.config deletedLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
        if(!emptyStr(updatedMstr))
            [updatedMstr writeToFile:[self.config substitutedLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
        if(!emptyStr(addedMstr))
            [addedMstr writeToFile:[self.config addedLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
        if(!emptyStr(unchangeMstr))
            [unchangeMstr writeToFile:[self.config unchangedLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
        if(!emptyStr(notransMstr))
            [notransMstr writeToFile:[self.config noTranslatedLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
        if(!emptyStr(ignoreMstr))
            [ignoreMstr writeToFile:[self.config ignoreLocalizedStringFileBy:i] atomically:YES encoding:4 error:0];
    }
    
    
    //merge dest files into single file for QA check
    NSString *fulldir = [self.config fullOutputPath:@""];
    NSString *qaname = fulldir.lastPathComponent;
    NSString *qadir = iFormatStr(@"%@/多语言文案_IOS/",[fulldir stringByDeletingLastPathComponent]);
    [YFStringMergeNDisperseHelper mergeDir:self.config.destDir toFile:iFormatStr(@"%@%@.strings",qadir,qaname)];
    
}

@end
