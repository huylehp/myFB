//
//  LoginViewController.m
//  myFB
//
//  Created by AnLab Mac on 11/24/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Cache.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIButton *loginButton;
    UILabel *loginInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designLoginView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginAction:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    SUCacheItem *item = [Cache getCacheItem];
    if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
        NSLog(@"logged in!");
        [self performSelector:@selector(gotoFeedViewController) withObject:self afterDelay:2.0];
    } else{
        [self addFBLoginButton];
    }
    // Do any additional setup after loading the view.
}

- (void)loginAction:(NSNotification *) notification
{
    NSLog(@"Login action");
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    NSLog(@"Token: %@", token.tokenString);
    if(!token){
        [self addFBLoginButton];
    } else {
        NSLog(@"It has token");
        SUCacheItem *item = [[SUCacheItem alloc] init];
        item.token = token;
        [Cache saveCacheItem:item];
        if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
            NSLog(@"Action token");
            if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
                [self performSelector:@selector(gotoFeedViewController) withObject:nil afterDelay:2.0];
            } else {
                [self addFBLoginButton];
            }
            
        }
    }
}
- (void)gotoFeedViewController{
    loginInfos.text = @"Logged in";
    loginButton.hidden = YES;
    NSLog(@"Tabbar view controller");
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.firstViewController = [[FirstViewController alloc] initWithNibName:nil bundle:NULL];
    appDelegate.secondViewController = [[SecondViewController alloc] initWithNibName:nil bundle:NULL];
    appDelegate.testViewController = [[TestViewController alloc] initWithNibName:nil bundle:NULL];
    appDelegate.firstSubViewController = [[ FirstSubViewController alloc] initWithNibName:nil bundle:NULL];
    [appDelegate.secondViewController setDelegate:appDelegate.firstSubViewController];
    appDelegate.tabBarController = [[UITabBarController alloc] init];
//    appDelegate.tabBarController.viewControllers = @[ appDelegate.testViewController];
//    appDelegate.tabBarController.viewControllers = @[ appDelegate.firstSubViewController,  appDelegate.secondViewController];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:appDelegate.firstSubViewController];
    appDelegate.tabBarController.viewControllers = @[ navController, appDelegate.secondViewController];
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
}
- (void)designLoginView
{
    [self.navigationItem setTitle:@"Login"];
    //    loginInfos.hidden = NO;
    loginInfos.text = @"Huy";
    loginInfos.textColor = [UIColor blackColor];
    loginInfos.frame = CGRectMake(50, 50, 180, 40);
    [self.view addSubview:loginInfos];
    
//    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    logo.center = self.view.center;
//    logo.image = [UIImage imageNamed:@"myFB-logo.png"];
//    [self.view addSubview:logo];
}
- (void)addFBLoginButton{
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, 180, 40);
    loginButton.backgroundColor = [UIColor orangeColor];
    loginButton.center = self.view.center;
    [loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];
}
- (void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"user_posts",@"email",@"user_photos"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(error){
            NSLog(@"Process error");
        } else if (result.isCancelled){
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in!");
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
