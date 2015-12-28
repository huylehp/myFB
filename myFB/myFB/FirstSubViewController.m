//
//  FirstSubViewController.m
//  myFB
//
//  Created by AnLab Mac on 12/10/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "FeedManager.h"
#import "AppDelegate.h"
#import "User.h"
#import "FSVCell.h"
#import "ImageScrollViewController.h"
@interface FirstSubViewController ()
@property (nonatomic, strong) User *myUser;
@property (nonatomic, strong) FeedManager *myFeedManager;
@property (nonatomic, strong) SecondViewController *second;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation FirstSubViewController
@synthesize activityIndicator;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Newfeeds";
        self.tabBarItem.image = [UIImage imageNamed:@"pages-2-24.png"];
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logOut:)];
        [self.navigationItem setRightBarButtonItem:myButton];
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     NSLog(@"Selected:%d", self.tabBarController.selectedIndex);
//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(actionInFirstView) userInfo:nil repeats:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self actionInFirstView];
    
//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(actionInFirstView) userInfo:nil repeats:YES];
//    self.myFeedManager = [[FeedManager alloc] init];
//    [self.myFeedManager makeFBRequestToPath: @"me/feed"withParameters:@{@"limit": @"10",} success:^(NSArray *result) {
//        NSLog(@"result count: %d", [result count]);
//    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table Load
- (void) actionInFirstView{
    NSLog(@"Reloading");
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    //    [activityIndicator setFrame:CGRectMake(160, 320, 50 , 50)];
    activityIndicator.color = [UIColor yellowColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    activityIndicator.layer.cornerRadius = 10;
    CGRect f = activityIndicator.bounds;
    f.size.width += 10;
    f.size.height += 10;
    activityIndicator.bounds = f;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    self.myUser = [[User alloc] init];
//    [self.feedTableView addSubview:self.refreshControl];
    [self downloadUserInfor];
    [self downloadFeedInfor];
    self.feedTableView.rowHeight = UITableViewAutomaticDimension;
    self.feedTableView.estimatedRowHeight = 200;
//    [self.myTimer invalidate];
}
- (void) downloadUserInfor
{
    self.myUser = [[User alloc] init];
    [self.myUser getUserProfileWithCompletionBlock:^(BOOL success, User *user) {
        if (success) {
            self.myUser = user;
            if (self.myUser.userImage) {
                [self.myUser downloadAvatarWithURLString:self.myUser.userImage withCompletion:^(UIImage *image, BOOL success) {
                    if (success == FALSE) {
                        NSLog(@"Error download");
                    }
//                    [self downloadFeedInfor];
                }];
            } else {
                NSLog(@"No userImage");
            }
        }
    }];
}
- (void) downloadFeedInfor
{
    self.myFeedManager = [FeedManager sharedManager];
    self.feedArrays = [NSMutableArray array];
    NSLog(@"Feed arrays allocated");
    [self.myFeedManager takingArrayOfFeedWithSuccess:^(NSMutableArray *result) {
        self.feedArrays = result;
        NSLog(@"feedArrays full of data");
        [activityIndicator removeFromSuperview];
        [self.feedTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.feedTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        NSLog(@"Reloaded");
    } failure:^(NSError *error) {
        NSLog(@"feedArrays error take data");
    }];
}
#pragma mark - Table View Action
- (void) retrieveData{
        FeedManager *newFeedManager = [[FeedManager alloc] init];
        NSDictionary *params = @{@"limit":@10};
        [newFeedManager makeFBRequestToPath:@"me/feed/" withParameters:params success:^(NSArray *result) {
            NSLog(@"Feed fried:%d", [result count]);
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.feedArrays) {
        self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.feedTableView.backgroundView = messageLabel;
        self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.feedArrays count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FSVCell";
    FSVCell *cell = (FSVCell *)[self.feedTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FSVCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row < [self.feedArrays count]) {
        Feed *f = (Feed *)[self.feedArrays objectAtIndex:indexPath.row];
        if (f != nil) {
            cell.userImage.image = self.myUser.avatar;
            if (f.story) {
                cell.userName.text = f.story;
            } else {
                cell.userName.text = self.myUser.userName;
            }
            cell.timeLabel.text = [f modifyTimeOfFeed];
            //    [f retrivePostTime:f.time];
            if (f.message) {
                cell.userMessage.text = f.message;
            } else {
                cell.userMessage.text = nil;
            }
            if (f.full_picture) {
                cell.feedImage.backgroundColor = [UIColor blackColor];
                if (!(f.image)) {
                    cell.feedImage.image = [UIImage imageNamed:@"WaitScreen.png"];
                    [f downloadFeedImagesWithFeed:indexPath andTable:tableView WithBlockOfRatio:^(UIImage *image, CGFloat ratio, BOOL success) {
                        if (success) {
                            NSLog(@"Downloaded");
                        } else {
                            UIAlertView *imageAlertView = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"Cannot download image from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [imageAlertView show];
                        }
                    }];

                    //
                } else {
                    cell.feedImage.image = [self imageWithImage:f.image scaledToWidth:self.feedTableView.frame.size.width];
                }
                
            } else {
                cell.feedImage.image = nil;
            }
        }

    } else {
        if (self.myFeedManager.isFull == FALSE) {
            cell.userName.text = @"Load more...";
        } else {
            cell.userName.text = @"End.";
        }
        cell.userImage.image = nil;
        cell.feedImage.image = nil;
        cell.timeLabel.text = nil;
        cell.userMessage.text = nil;
    }
//    if (indexPath.row < [self.feedArrays count]) {
//    } else {
//        cell.userName.text = @"Load more...";
//        cell.userImage = nil;
//        cell.feedImage = nil;
//        cell.timeLabel = nil;
//        cell.userMessage = nil;
//    }
    return cell;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.feedTableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Selected");
    NSLog(@"%d", indexPath.row);
    if (indexPath.row < [self.feedArrays count]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Feed *f = (Feed *)[self.feedArrays objectAtIndex:indexPath.row];
        NSLog(@"Full picture: %@", f.full_picture);
        if (f.image) {
            ImageScrollViewController *imageScrollView = [[ImageScrollViewController alloc] init];
            imageScrollView.imageToView = f.image;
            if (f.message) {
                imageScrollView.message = f.message;
            }
//            [self.navigationController presentViewController:self.navigationC animated:YES completion:nil];
//            [self.navigationController showViewController:imageScrollView sender:nil];
            [self.navigationController pushViewController:imageScrollView animated:YES];
        }
    } else {
        NSLog(@"Load more...");
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self addMore];
    }
}
- (void)addMore{
    if ([self.myFeedManager isFull] == FALSE) {
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [self.myFeedManager pagingMoreNewFeedWithPagingString:self.myFeedManager.paging.next withCompletionSuccess:^(NSArray *success) {
            [self.feedArrays addObjectsFromArray:success];
            [activityIndicator removeFromSuperview];
            [self.feedTableView reloadData];
        } failure:^(NSError *failure) {
            NSLog(@"Error:%@", failure);
        }];
    } else{
        NSLog(@"Full");
    }

}
- (void) viewWillLayoutSubviews{
    [self.feedTableView reloadData];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 200;
//}
#pragma mark - Second View Controller
- (void)delegateMethod:(NSString *)message{
    NSLog(@"Message: %@", message);
//    [self performSelectorOnMainThread:@selector(actionInFirstView) withObject:nil waitUntilDone:YES];
    [self actionInFirstView];

}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Navigation button action
- (void)logOut:(id)sender{
    NSLog(@"Logged out");
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.loginViewController];
}
- (IBAction)logoutButton:(id)sender {
    NSLog(@"Logged out");
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.navigationController];
}

- (IBAction)updateButton:(id)sender {
    [self actionInFirstView];
}

@end
