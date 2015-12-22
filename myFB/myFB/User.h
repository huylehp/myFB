//
//  User.h
//  myFB
//
//  Created by AnLab Mac on 11/20/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@class User;
@protocol UserDelegate <NSObject>

- (void)inforOfUser:(User *)userData;
@end
@interface User : NSObject
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSString * userCover;
@property (nonatomic, strong) NSString * userImage;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) UIImage * avatar;
@property (nonatomic, weak) id <UserDelegate> delegate;

- (void)getUserProfileFromFb;
- (void)logOfUserProfile;
- (void)setUserID:(NSString *)userID WithName:(NSString *)userName WithImage:(NSString *)userImage WithCover:(NSString *)userCover;
- (NSString *)getLinkOfUserImage:(id) resultImage;
- (NSString *)getLinkOfUserCover:(id) resultCover;
- (void)getUserProfileWithCompletionBlock:(void (^)(BOOL success, User * user)) completionBlock;
- (void)downloadAvatarWithURLString:( NSString *)userImage withCompletion:(void (^) (UIImage *image, BOOL success))block;
- (void)cancelDownload;
@end
