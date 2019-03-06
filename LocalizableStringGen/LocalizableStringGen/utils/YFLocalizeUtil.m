
//
//  YFLocalizeUtil.m
//  LocalizableStringGen
//
//  Created by yf on 2018/11/23.
//  Copyright © 2018 yf. All rights reserved.
//

#import "YFLocalizeUtil.h"


@implementation YFLocalizeUtil


#pragma mark - utils
+(void)append:(NSMutableString *)mstr key:(NSString *)key val:(NSString *)val{
    if([val containsString:@"++++++"])
        val=key;
    [mstr appendFormat:@"\"%@\" = \"%@\";\n",key,val];
}

+(NSString *)handleCheckResult:(NSTextCheckingResult *)result srcStr:(NSString *)srcStr range:(NSRange *)orange{
    for(int i=1;i<result.numberOfRanges;i++){
        NSRange range = [result rangeAtIndex:i];
        if(range.location!=NSNotFound){
            if(orange)
                *orange=range;
            return [srcStr substringWithRange:range];
        }
    }
    NSAssert(NO, @"----wrong matching range-----");
    return @"";
}

+(void)write:(NSString *)destStr to:(NSString *)file dir:(NSString *)dir{
    if(emptyStr(destStr))return;
    NSString *path = iFormatStr(@"%@%@",dir,file);
    [destStr writeToFile:path atomically:YES encoding:4 error:0];
}


+(NSString *)strFromValidFile:(NSString *)file dir:(NSString *)dir fileExts:(NSArray *)fileExts excludeFiles:(NSArray *)excludeFiles{
    NSString *slash = @"";
    if(![dir hasSuffix:@"/"])
        slash = @"/";
        NSString *path = iFormatStr(@"%@%@%@",dir,slash,file);
    
    BOOL isDir = NO;
    BOOL exist = [iFm fileExistsAtPath:path isDirectory:&isDir];
    if(!exist||isDir)return nil;
    
    if([excludeFiles containsObject:path])return nil;
    
    BOOL valid = NO;
    for(NSString *ext in fileExts){
        if([path hasSuffix:ext]){
            valid=YES;
            break;
        }
    }
    if(!valid)return nil;
    return [NSString stringWithContentsOfFile:path encoding:4 error:0];
}

+(NSMutableDictionary *)localStringDictWithLowerKeyFrom:(NSString *)localstringFile{
    NSString *ostr = [NSString stringWithContentsOfFile:localstringFile encoding:4 error:0];
    NSArray *ary = [ostr componentsSeparatedByString:@"\";"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:ary.count];
//    NSMutableArray *mary = [NSMutableArray array];
    for(int i=0;i<ary.count-1;i++){
        NSString *str = ary[i];
        NSRange range = [str rangeOfString:@"\"\\s*=\\s*\"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, str.length)];
        
        NSAssert(range.location!=NSNotFound, @"----- Range not found ----- ");
        
        NSArray *sary = @[[str substringToIndex:range.location],[str substringFromIndex:range.location+range.length]];
        NSString *key = [sary[0] substringFromIndex:[sary[0] rangeOfString:@"\""].location+1].lowercaseString;
//        NSString *val = [dict valueForKey:key];
//        if(val)
//            [mary addObject:iFormatStr(@"%@ = %@",key,val)];
        [dict setObject:sary[1] forKey:key] ;
    }
    return dict;
}

+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile{
    return [self localStringDictFrom:localstringFile revert:NO];
}

//revert:YES  key 与value位置互换  ,NO 正常key value
+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile  revert:(BOOL)revert{
    NSMutableString *mstr = [NSMutableString string];
    return [self localStringDictFrom:localstringFile revert:revert multiOccuredString:mstr];
}


//revert:YES  key 与value位置互换  ,NO 正常key value
+(NSMutableDictionary *)localStringDictFrom:(NSString *)localstringFile  revert:(BOOL)revert multiOccuredString:(NSMutableString *)multiMstr{
    NSString *ostr = [NSString stringWithContentsOfFile:localstringFile encoding:4 error:0];
    NSArray *ary = [ostr componentsSeparatedByString:@"\";"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:ary.count];
    //    NSMutableArray *mary = [NSMutableArray array];
    for(NSInteger i=0;i<ary.count-1;i++){
        NSString *str = ary[i];
        NSRange range = [str rangeOfString:@"\"\\s*=\\s*\"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, str.length)];
        
        NSAssert(range.location!=NSNotFound, @"----- Range not found ----- ");
        
        NSArray *sary = @[[str substringToIndex:range.location],[str substringFromIndex:range.location+range.length]];
        NSString *key = [sary[0] substringFromIndex:[sary[0] rangeOfString:@"\""].location+1];
        //        NSString *val = [dict valueForKey:key];
        //        if(val)
        //            [mary addObject:iFormatStr(@"%@ = %@",key,val)];
        NSString *actkey ,*actval;
        
        if(revert){
            actkey=sary[1];
            actval=key;
        }else{
            actval=sary[1];
            actkey=key;
        }
        if(multiMstr && dict[actkey]){
            [self append:multiMstr key:actkey val:actval];
        }else{
            [dict setObject:actval forKey:actkey];
        }
    }
    return dict;
}

+(NSMutableDictionary *)newDict{
    return [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/Users/yf/Desktop/LocalizableDict"]];
}
+(void)saveDict:(NSDictionary *)dict{
    [dict writeToFile:@"/Users/yf/Desktop/LocalizableDict" atomically:YES];
}
+(void) localized{
//    NSMutableDictionary *dict = [self originDict];
//    //        NSMutableDictionary *dict = newDict();
//    /////----------------2
//    
//    NSString *targetstr = [NSString stringWithContentsOfFile:@"/Users/yf/Desktop/Localizable2.strings" encoding:4 error:0];
//    NSArray *targetAry = [targetstr componentsSeparatedByString:@"\";"];
//    NSInteger containCount = 0;
//    NSMutableString *newtargetStr = [NSMutableString string];
//    for(NSString *str in targetAry){
//        if(str.length<4)continue;
//        NSArray *sary = [str componentsSeparatedByString:@"\" = \""];
//        NSString *key = [sary[0] substringFromIndex:[sary[0] rangeOfString:@"\""].location+1];
//        NSString *val = sary[1];
//        NSString *valnew = [dict objectForKey:key.lowercaseString];
//        if(valnew){
//            [dict removeObjectForKey:key.lowercaseString];
//        }else{
//            valnew=[dict objectForKey:val.lowercaseString];
//            if(valnew)
//                [dict removeObjectForKey:val.lowercaseString];
//        }
//        if(valnew){
//            containCount++;
//            [self append:newtargetStr key:key val:valnew];
//            NSLog(@"%ld---%@",containCount,key);
//            
//        }else{
//            [self append:newtargetStr key:key val:val];
//        }
//        
//    }
//    
//    NSLog(@"%ld---%@",containCount,newtargetStr);
//    [self saveDict:dict];
//    [newtargetStr writeToFile:@"/Users/yf/Desktop/LocalizableDictstr" atomically:YES encoding:4 error:0];
}



@end

NSString *workingPath(NSString *path){
    return iFormatStr(@"%@%@",YF_LOCALIZE_BASE_WORKING_DIR,path);
}
NSString *projectPath(NSString *path){
    return iFormatStr(@"%@%@",YF_LOCALIZE_BASE_PROJECT_DIR,path);
}
