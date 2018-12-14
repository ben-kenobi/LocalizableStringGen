//
//  YFLocalizeUtil.h
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YF_LOCALIZE_BASE_WORKING_DIR;
extern NSString *const YF_LOCALIZE_BASE_PROJECT_DIR;

NSString *workingPath(NSString *path);
NSString *projectPath(NSString *path);


@interface YFLocalizeUtil : NSObject
+(void)append:(NSMutableString *)mstr key:(NSString *)key val:(NSString *)val;

+(NSString *)handleCheckResult:(NSTextCheckingResult *)result srcStr:(NSString *)srcStr range:(NSRange *)orange;

+(void)write:(NSString *)destStr to:(NSString *)file dir:(NSString *)dir;

+(NSString *)strFromValidFile:(NSString *)file dir:(NSString *)dir fileExts:(NSArray *)fileExts excludeFiles:(NSArray *)excludeFiles;


+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile;

//revert:YES  key 与value位置互换  ,NO 正常key value
+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile  revert:(BOOL)revert;
+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile  revert:(BOOL)revert multiOccuredString:(NSMutableString *)multiMstr;
/**
将字典的key lowercase
 */
+(NSMutableDictionary *)localStringDictWithLowerKeyFrom:(NSString *)localstringFile;
@end

