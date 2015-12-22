//
//  FirstViewController.m
//  myFB
//
//  Created by AnLab Mac on 11/25/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "FirstViewController.h"
#import "FeedManager.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "AppDelegate.h"
#import "User.h"
@interface FirstViewController ()

@end

@implementation FirstViewController{
    UILabel *myLabel;
    UIButton *logoutButton;
    UIActivityIndicatorView *activityIndicator;
    UIImageView *waitView;
    User *myUser;
    UIImage *userImage;
    FeedManager *myFeedManager;
    CGFloat newRatio;
    
}
@synthesize tableView ,feedArrays;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the first Tab");
    
    if (self) {
        //set the title for the tab
        self.title = @"New feeds";
        //set the image icon for the tab
        self.tabBarItem.image = [UIImage imageNamed:@"pages-2-24.png"];
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self actionInFirstView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View is displayed for the first Tab");
    [self labelOfFeed];
    [self designTableView];
    [self designLogout];
    //activity
    [self actionInFirstView];
    
}
-(void)delegateMethod:(NSString *)message{
    NSLog(@"Message: %@", message);
    [self actionInFirstView];
}
-(void)stopActivity
{
    [activityIndicator removeFromSuperview];
}
-(void)actionInFirstView{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
//    [activityIndicator setFrame:CGRectMake(160, 320, 50 , 50)];
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
    //    [self performSelector:@selector(stopActivity)withObject:nil afterDelay:5];
    //end act
    myUser = [[User alloc] init];
    [myUser getUserProfileWithCompletionBlock:^(BOOL success, User *user) {
        if (success) {
            myUser = user;
            userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:myUser.userImage]]];
        }
    }];
    myFeedManager = [FeedManager sharedManager];
    feedArrays = [NSMutableArray array];
    NSLog(@"feed");
    [myFeedManager takingArrayOfFeedWithSuccess:^(NSMutableArray *result) {
        feedArrays = result;
//        NSLog(@"Feed: %li", [feedArrays count]);
        //        [self displayActivityIndicator];
        //        for (Feed *feed in feedArrays) {
        //            if (feed.full_picture) {
        //                UIImage *cellImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:feed.full_picture]]];
        //                feed.image = cellImage;
        //            }
        //        }
        //        [self hideActivityIndicator];
        [activityIndicator removeFromSuperview];
        NSLog(@"Reload");
        [tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"myFeedManager:%@", error);
    }];
    NSLog(@"feed2");
}
- (void)labelOfFeed
{
    myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 100)];
    myLabel.text = @"NewFeeds";
    myLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [self.view addSubview:myLabel];

}
- (void)designLogout
{
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = [UIColor grayColor];
    logoutButton.frame = CGRectMake( 200, 40, 100, 40);
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}
- (void)logoutButtonClicked{
    NSLog(@"Logged out");
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.navigationController];
}
- (void)designTableView
{
    CGFloat heightOfTableView = self.view.frame.size.height - myLabel.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    CGFloat widthOfTableView = self.view.frame.size.width;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, widthOfTableView, heightOfTableView)];
    [tableView setBackgroundColor:[UIColor darkGrayColor]];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [self.view addSubview:tableView];
    //Constraints
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat getConst1 = myLabel.frame.size.height;
    CGFloat getConst2 = self.tabBarController.tabBar.frame.size.height;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:getConst1];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:getConst2];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraints:@[top, left, bottom, right]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedArrays count];
//    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"feedCell";
//    FeedTVCell *cell = (FeedTVCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedTVCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    cell.userImage.image = userImage;
//    Feed *f = (Feed *)[feedArrays objectAtIndex:indexPath.row];
//    if (f.story) {
//        cell.feedLabel.text = f.story;
//    } else {
//        cell.feedLabel.text = myUser.userName;
//    }
//    if (f.full_picture) {
////        cell.feedImage.contentMode = UIViewContentModeScaleAspectFit;
//        cell.feedImage.backgroundColor = [UIColor blackColor];
//        cell.feedImage.image = [UIImage imageNamed:@"WaitScreen.png"];
//        if (!(f.image)) {
//            [f downloadFeedImagesWithFeed:indexPath andTable:self.tableView WithBlockOfRatio:^(UIImage *image,CGFloat ratio, BOOL success) {
//                if (success) {
////                    NSLog(@"Count: %d", cell.feedImage.constraints.count);
//                    NSLayoutConstraint * newConstraint = nil;
//                    for (NSLayoutConstraint * constraint in cell.feedImage.constraints) {
//                        if ([constraint.identifier isEqual:@"feedRatio"]) {
////                            NSLog(@"ratio: %f", ratio);
////                            NSLog(@"multi: %f", constraint.multiplier);
//                            newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:ratio constant:0];
//                            [cell.feedImage removeConstraint:constraint];
//
//                        }
//
//                    }
//                    if (newConstraint) {
//                        newConstraint.identifier = @"feedRatio";
//                        newConstraint.priority = 750;
//                        [cell.feedImage addConstraint:newConstraint];
//                        [cell.feedImage setNeedsUpdateConstraints];
//                    }
////                    NSLog(@"Count: %d", cell.feedImage.constraints.count);
//                    for (NSLayoutConstraint * constraint in cell.feedImage.constraints) {
//                        NSLog(@"id: %@", constraint.identifier);
//                        if ([constraint.identifier isEqual:@"feedRatio"]) {
////                            NSLog(@"multi:%f", constraint.multiplier);
//                            constraint.priority = 750;
//                        }
//                        if ([constraint.identifier isEqual:@"feed_height"]) {
//                            constraint.priority = 500;
//                        }
//                    }
//                }
//            }];
//        }
//        cell.feedImage.image = f.image;
//        if (f.ratio) {
//            NSLayoutConstraint * newConstraint = nil;
//            for (NSLayoutConstraint * constraint in cell.feedImage.constraints) {
//                if ([constraint.identifier isEqual:@"feedRatio"]) {
//                    newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:f.ratio constant:0];
//                    [cell.feedImage removeConstraint:constraint];
//                    
//                }
//                
//            }
//            if (newConstraint) {
//                newConstraint.identifier = @"feedRatio";
//                newConstraint.priority = 750;
//                [cell.feedImage addConstraint:newConstraint];
//                [cell.feedImage setNeedsUpdateConstraints];
//            }
////            NSLog(@"Count: %d", cell.feedImage.constraints.count);
//            for (NSLayoutConstraint * constraint in cell.feedImage.constraints) {
////                NSLog(@"id: %@", constraint.identifier);
//                if ([constraint.identifier isEqual:@"feedRatio"]) {
////                    NSLog(@"multi:%f", constraint.multiplier);
//                    constraint.priority = 750;
//                }
//                if ([constraint.identifier isEqual:@"feed_height"]) {
//                    constraint.priority = 500;
//                }
//            }
//        }
//    } else {
//        for (NSLayoutConstraint * constraint in cell.feedImage.constraints) {
//            if ([constraint.identifier isEqual:@"feedRatio"]) {
////                [cell.feedImage removeConstraint:constraint];
//                constraint.priority = 500;
//            }
//            if ([constraint.identifier isEqual:@"feed_height"]) {
//                constraint.priority = 750;
//            }
//        }
//        cell.feedImage.image = nil;
//
//    }
//    if (f.message) {
//        cell.textLabel.text = f.message;
//        for (NSLayoutConstraint * constraint in cell.contentView.constraints) {
//            if ([constraint.identifier isEqual:@"text_height"]) {
//                constraint.priority = 999;
//            }
//        }
//        
//    } else {
//        cell.textLabel.text = nil;
////        NSLog(@"Count: %d", cell.contentView.constraints.count);
//        for (NSLayoutConstraint * constraint in cell.contentView.constraints) {
//            if ([constraint.identifier isEqual:@"text_height"]) {
//                constraint.priority = 750;
//            }
//        }
//    }
//
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    Feed *feed = [self.feedArrays objectAtIndex:indexPath.row];
////    if(feed.full_picture ){
////        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithString:feed.full_picture]]]];
////        return 60.0 + [Feed getResizeOfFullImage:image].height;
////    } else {
//        return 150.0;
////    }
//}
////- (void) viewDidLayoutSubviews{
////    [self.tableView reloadData];
////}
////- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
////{
////    [self.tableView reloadData];
////}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150.0;
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
