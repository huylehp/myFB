//
//  ViewController.m
//  myFB
//
//  Created by AnLab Mac on 11/13/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Cache.h"

@interface ViewController ()


@end

@implementation ViewController
{
    UIButton *loginButton;
    UIButton *logoutButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newActionLogin:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_currentProfileChanged:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    [self designLoginButton];
//    self.reDirectLabel.hidden = YES;
    SUCacheItem *item = [Cache getCacheItem];
    if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
        NSLog(@"Logged in!");
        [self designLogout];
        [self performSegueWithIdentifier:@"mySegue" sender:nil];
    } else {
        [self designLoginButton];
    }
//[feedMana testListFeedWithToken:self.token];
}
- (void) newActionLogin:(NSNotification *)notification
{
    NSLog(@"Hello world");
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    if (!token) {
        [self designLoginButton];
    }else{

        NSLog(@"%@", profile.userID);
        NSLog(@"token:%@", token.tokenString);
        SUCacheItem *item = [[SUCacheItem alloc] init];
        item.token = token;
        [Cache saveCacheItem:item];
        if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
            NSLog(@"Logged in!");
            [self designLogout];
        } else {
            [self designLoginButton];
        }
    }
}
- (void)_currentProfileChanged:(NSNotification *)notification
{
    NSLog(@"Action 2");
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    NSLog(@"Profile:%@", profile.userID);
}
- (void)designLoginButton
{
    NSLog(@"abc");
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor grayColor];
    loginButton.frame = CGRectMake(0, 0, 180, 40);
    loginButton.center = self.view.center;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}
- (void)designLogout
{
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = [UIColor grayColor];
    logoutButton.frame = CGRectMake( 90, 400, 180, 40);
    logoutButton.center = self.view.center;
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}
- (void)logoutButtonClicked{
    NSLog(@"Logged out");
//    NSLog(@"%@", [FBSDKAccessToken currentAccessToken].tokenString);
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    self.loginLabel.hidden = YES;
    [self designLoginButton];
//    NSLog(@"%@", [FBSDKAccessToken currentAccessToken].tokenString);
}
- (void) loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"user_posts",@"email",@"user_photos"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(error){
            NSLog(@"Process error");
        } else if (result.isCancelled){
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in!");
            [self performSegueWithIdentifier:@"mySegue" sender:nil];
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue");
    if ([[segue identifier] isEqualToString:@"mySegue"])
    {
        
    }
}

@end
