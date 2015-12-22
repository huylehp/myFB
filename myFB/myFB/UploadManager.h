//
//  UploadManager.h
//  myFB
//
//  Created by AnLab Mac on 12/3/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@protocol UploadManagerDelegate <NSObject>

@required
- (void)updateHasBeenDone;
@end
@interface UploadManager : NSObject<FBSDKSharingDelegate>
@property (strong, nonatomic) NSArray *arrayOfUploadImage;
@property (strong, nonatomic) FBSDKShareAPI *shareAPI;
@property (weak, nonatomic) id <UploadManagerDelegate> delegate;
- (void) takeUploadImage:(UIImage *)uploadImage;
- (void) takeArrayOfUploadImage:(NSMutableArray *)uploadImageArrays;
- (void) uploadArrayOfUploadImages;
- (void) uploadImage:(UIImage *)image withCaption:(NSString *)caption;
- (void) uploadMessageWithString:(NSString *)string;

@end
