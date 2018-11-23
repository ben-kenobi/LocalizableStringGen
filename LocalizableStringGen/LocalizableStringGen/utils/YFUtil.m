//
//  YFUtil.m
//  BatteryCam
//
//  Created by yf on 2018/8/8.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "YFUtil.h"
#import "SVProgressHUD.h"


@implementation iPop
+(void)showHUDMsg:(NSString*)msg{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showSuccessWithStatus:msg];
}

+(void)showMsg:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showInfoWithStatus:msg];
}
+(void)showSuc:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:msg];
}
+(void)showError:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showErrorWithStatus:msg];
}
+(void)showProgWithMsg:(NSString *)msg{
    [SVProgressHUD setBackgroundLayerColor:iColor(0, 0, 0, .6)];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeCustom)];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD  showWithStatus:msg];
}
+(void)showProg{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD  show];
}
+(void)dismProg{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD dismiss];
}
+(void)toastWarn:(NSString*)msg{
    if(!msg||[msg isEqualToString:@"Request failed: unauthorized (401)"]==YES||[msg containsString:@"已取消"]==YES)return;
    [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iWarnTipColor icon:img(@"warning_icon")];
    
    //    runOnMain(^{
    //        //        iApp.windows[iApp.windows.count-1].makeToast(msg)
    //       /* [frontestWindow() makeToast:msg duration:1.5 position:nil title:nil image:nil style:[CSToastManager sharedStyle] completion:nil];*/
    //    });
}
+(void)toastSuc:(NSString *)msg{
    if(!msg)return;
    [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iSucTipColor icon:[img(@"voice_con") renderWithColor:iSucTipColor]];
}
+(void)toastInfo:(NSString *)msg{
    if(!msg)return;
    [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iInfoTipColor icon:[img(@"voice_con") renderWithColor:iInfoTipColor]];
}

+(void)bannerWarn:(NSString*)msg{
    [self bannerWarn:msg iden:@"show_msg"];
}
+(void)bannerSuc:(NSString *)msg{
    [self bannerSuc:msg iden:@"show_msg"];
}
+(void)bannerInfo:(NSString *)msg{
    [self bannerInfo:msg iden:@"show_msg"];
}

+(void)bannerWarn:(NSString*)msg iden:(NSString *)iden{
    if(!msg)return;
    [UIUtil showMsgAt:[UIViewController curVC].view msg:msg color:iInfoTipColor icon:img(@"voice_con")  iden:iden];
}
+(void)bannerSuc:(NSString *)msg iden:(NSString *)iden{
    if(!msg)return;
    [UIUtil showMsgAt:[UIViewController curVC].view msg:msg color:iInfoTipColor icon:[img(@"voice_con") renderWithColor:iSucTipColor]  iden:iden];
}
+(void)bannerInfo:(NSString *)msg iden:(NSString *)iden{
    if(!msg)return;
    [UIUtil showMsgAt:[UIViewController curVC].view msg:msg color:iInfoTipColor icon:[img(@"voice_con") renderWithColor:iInfoTipColor]  iden:iden];
}
+(void)dismissBannerBy:(NSString *)iden{
    [UIUtil dismissBannerBy:iden];
}
@end

@implementation ALUtil:NSObject
+(void)setImgFromALURL:(NSURL*)alurl cb:(void(^)(UIImage *))cb{
    if(!alurl){
        if(cb)cb(nil);
        return;
    }
        
    ALAssetsLibraryAssetForURLResultBlock resultblock=^(ALAsset *asset){
        ALAssetRepresentation* rep = asset.defaultRepresentation;
        __unsafe_unretained CGImageRef iref =  [rep fullResolutionImage];
        UIImage * image = [UIImage imageWithCGImage:iref];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(cb)cb(image);
        });
    };
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
        iLog(@"\n-----load ALAssets fail------\n");
        if(cb)cb(nil);
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:alurl resultBlock:resultblock failureBlock:failureblock];
}
+(void)videoFromALURL:(NSURL *)alurl cb:(void(^)(ALAsset *asset))cb{
    if(!alurl){
        if(cb)cb(nil);
        return;
    }
    ALAssetsLibraryAssetForURLResultBlock resultblock=^(ALAsset *asset){
        if(cb)cb(asset);
    };
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
        iLog(@"\n-----load ALAssets fail------\n");
        if(cb)cb(nil);
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:alurl resultBlock:resultblock failureBlock:failureblock];
}
@end
