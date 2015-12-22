//
//  UploadManager.m
//  myFB
//
//  Created by AnLab Mac on 12/3/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "UploadManager.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@implementation UploadManager
@synthesize arrayOfUploadImage;

#pragma mark - UploadManager
- (FBSDKShareAPI *) shareAPI{
    if(!_shareAPI){
        _shareAPI = [[FBSDKShareAPI alloc] init];
    }
    return _shareAPI;
}
- (void)takeUploadImage:(UIImage *)uploadImage{
    if (uploadImage) {
        arrayOfUploadImage = [NSArray arrayWithObject:uploadImage];
    } else {
        NSLog(@"No image");
        return;
    }
}
- (void)uploadMessageWithString:(NSString *)string{
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/feed"
                                      parameters:@{ @"message": string,}
                                      HTTPMethod:@"POST"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"Error to post a message");
            } else {
                NSLog(@"Posted");
            }
        }];
    }

}
- (void)takeArrayOfUploadImage:(NSMutableArray *)uploadImageArrays
{
    
}
- (void)uploadArrayOfUploadImages{
    if (arrayOfUploadImage) {
        UIImage *imageUpload = (UIImage *)[arrayOfUploadImage objectAtIndex:0];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = imageUpload;
        photo.userGenerated = YES;
        photo.caption = [NSString stringWithFormat:@""];

        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        [FBSDKShareAPI shareWithContent:content delegate:self];
    } else {
        NSLog(@"No image to upload on Facebook");
    }
}
- (void)uploadImage:(UIImage *)image withCaption:(NSString *)caption{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    photo.caption = caption;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    self.shareAPI.delegate = self;
    self.shareAPI.shareContent = content;
    [self.shareAPI share];
    NSLog(@"UploadImage");

}
#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"sharer:%@", results);
    [self.delegate updateHasBeenDone];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
}

- (void) sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}
@end
