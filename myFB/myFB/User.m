//
//  User.m
//  myFB
//
//  Created by AnLab Mac on 11/20/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "User.h"
#define kAvaIconSize 50

@interface User ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end
@implementation User

- (void) getUserProfileFromFb
{
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest * fbRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/"
                                                                          parameters:@{@"fields":@"cover,id,name,picture",}
                                                                          HTTPMethod:@"GET"];
        [fbRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"Cant query data of user profile");
            } else {
//                NSLog(@"%@", result);
                
                [self setUserID:result[@"id"]
                       WithName:result[@"name"]
                      WithImage:[self getLinkOfUserImage:result[@"picture"]]
                      WithCover:[self getLinkOfUserCover:result[@"cover"]]];
//                [self logOfUserProfile];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(inforOfUser:)]) {
                    [self.delegate inforOfUser:self];
                }
            }
        }];
    }
}

- (void) getUserProfileWithCompletionBlock:(void (^)(BOOL, User *))completionBlock
{
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *fbRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:@{@"fields":@"cover, id, name, picture",} HTTPMethod:@"GET"];
        [fbRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"Cant query data of user profile");
                completionBlock(NO, nil);
            } else {
                User *newUser = [[User alloc] init];
                [newUser setUserID:result[@"id"]
                       WithName:result[@"name"]
                      WithImage:[self getLinkOfUserImage:result[@"picture"]]
                      WithCover:[self getLinkOfUserCover:result[@"cover"]]];
                completionBlock(YES, newUser);
            }
        }];
        
    }
}
- (void) logOfUserProfile
{
    NSLog(@"Id: %@", self.userID);
    NSLog(@"Username: %@", self.userName);
    NSLog(@"Image: %@", self.userImage);
    NSLog(@"Cover: %@", self.userCover);
}
- (void) setUserID:(NSString *)userID WithName:(NSString *)userName WithImage:(NSString *)userImage WithCover:(NSString *)userCover
{
    self.userID = userID;
    self.userName = userName;
    self.userImage = userImage;
    self.userCover = userCover;
}
- (NSString *) getLinkOfUserImage:(id)resultImage{
    NSString * tmpLink = resultImage[@"data"][@"url"];
    
    return tmpLink;
}
- (NSString *) getLinkOfUserCover:(id)resultCover
{
    NSString * tmpLink = resultCover[@"source"];
    
    return tmpLink;
}
- (void)downloadAvatarWithURLString:(NSString *)userImage withCompletion:(void (^) (UIImage *image, BOOL success))block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.userImage]];
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse * response, NSError * error) {
        if (error != nil) {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                // then your Info.plist has not been properly configured to match the target server.
                //
//                abort();
                NSLog(@"Cannot download ava");
                self.avatar = [UIImage imageNamed:@"user-8-50.png"];
                block(self.avatar, FALSE);
            }
        }
        UIImage *image = [[UIImage alloc] initWithData:data];
        //Resize
        CGRect rect = CGRectMake(0, 0, kAvaIconSize, kAvaIconSize);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImagePNGRepresentation(img);
        UIImage *newImage = [UIImage imageWithData:imageData];
        
        self.avatar = newImage;
        block(self.avatar, TRUE);
    }];
    [self.sessionTask resume];
}

- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}
@end
