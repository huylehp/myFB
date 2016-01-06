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
#import "ScrollView.h"
#import "MBProgressHUD.h"
#define I_OS_7  ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)


@interface FirstSubViewController ()
@property (nonatomic, strong) User *myUser;
@property (nonatomic, strong) FeedManager *myFeedManager;
@property (nonatomic, strong) SecondViewController *second;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *offScreenCell;

@end

@implementation FirstSubViewController
@synthesize activityIndicator;
@synthesize offScreenCell;
#pragma mark - initMethod
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
        offScreenCell = [NSMutableDictionary dictionary];
    }
    
    return self;
}
#pragma mark - viewAdjust
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
     NSLog(@"Selected:%d", self.tabBarController.selectedIndex);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (I_OS_7) {
        NSLog(@"Ios 7");
    }else {
        NSLog(@"IOs 8");
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.feedTableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(actionInFirstView) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setBackgroundColor:[UIColor blackColor]];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self actionInFirstView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews{
    [self.feedTableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.feedTableView reloadData];
}
#pragma mark - Action of table
- (void) actionInFirstView{
    NSLog(@"Reloading");
//    activityIndicator.hidesWhenStopped = NO;
//    [self.view addSubview:activityIndicator];
//    [activityIndicator startAnimating];
    self.myUser = [[User alloc] init];
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
//        [activityIndicator removeFromSuperview];
        [self.feedTableView reloadData];
//        [self.refreshControl endRefreshing];
        if (self.refreshControl) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            
            [self.refreshControl endRefreshing];
        }
        NSLog(@"Reloaded");
    } failure:^(NSError *error) {
        NSLog(@"feedArrays error take data");
    }];
}

- (void) retrieveData{
    FeedManager *newFeedManager = [[FeedManager alloc] init];
    NSDictionary *params = @{@"limit":@10};
    [newFeedManager makeFBRequestToPath:@"me/feed/" withParameters:params success:^(NSArray *result) {
        NSLog(@"Feed fried:%d", [result count]);
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)addMore{
    if ([self.myFeedManager isFull] == FALSE) {
        [self.myFeedManager pagingMoreNewFeedWithPagingString:self.myFeedManager.paging.next withCompletionSuccess:^(NSArray *success) {
            [self.feedArrays addObjectsFromArray:success];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSelector:@selector(reloadTableData) withObject:self afterDelay:1.0];
            //            [self.feedTableView reloadData];
        } failure:^(NSError *failure) {
            NSLog(@"Error:%@", failure);
        }];
    } else{
        NSLog(@"Full");
    }
    
}
- (void)reloadTableData{
    [activityIndicator removeFromSuperview];
    [self.feedTableView reloadData];
}
#pragma mark - UITableViewDelegate
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
    return [self.feedArrays count] ;
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
            [cell setUpCellWithFeed:f andUser:self.myUser withTableView:tableView andIndexPath:indexPath];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    if (indexPath.row < [self.feedArrays count]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Feed *f = (Feed *)[self.feedArrays objectAtIndex:indexPath.row];
        NSLog(@"Full picture: %@", f.full_picture);
        if (f.image) {
            ImageScrollViewController *imageScrollView = [[ImageScrollViewController alloc] init];
            ScrollView *newScrollView = [[ScrollView alloc] init];
            newScrollView.imageToView = [self imageWithImage:f.image scaledToWidth:self.view.bounds.size.width];
//            newScrollView.imageToView = f.image;
            imageScrollView.imageToView = f.image;
//            imageScrollView.imageToView = [self imageWithImage:f.image scaledToWidth:self.view.bounds.size.width];
            if (f.message) {
                imageScrollView.message = f.message;
            }
//            if (newScrollView.imageToView) {
//                [self.navigationController pushViewController:newScrollView animated:YES];
//            }
            if (imageScrollView.imageToView) {
                [self.navigationController pushViewController:imageScrollView animated:YES];
            }
        }
    } else {
        NSLog(@"Load more...");
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self addMore];
    }
}
//#ifdef I_OS_7
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"FSVCell";
//    FSVCell *cell = (FSVCell *)[offScreenCell objectForKey:cellIdentifier];
//    if (cell == nil) {
//        cell = [[FSVCell alloc] init];
//        [offScreenCell setObject:cell forKey:cellIdentifier];
//    }
//    Feed *f = (Feed *)[self.feedArrays objectAtIndex:indexPath.row];
//    if (f != nil) {
//        [cell setUpCellWithFeed:f andUser:self.myUser withTableView:tableView andIndexPath:indexPath];
//    }
//    
//    // Get the actual height required for the cell
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height;
//}
//
//
//#endif
//- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger lastRow = [tableView numberOfRowsInSection:0] - 1;
//    if ([indexPath row] == lastRow) {
//        if (self.myFeedManager.isFull == FALSE) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [self performSelector:@selector(addMore) withObject:nil afterDelay:1.5];
//        }
//    }
//}
#pragma mark - SecondViewController delegate

- (void)delegateMethod:(NSString *)message{
    NSLog(@"Message: %@", message);
    [self actionInFirstView];

}

#pragma mark - ScaleImage
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
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling > scrollView.contentSize.height) {
        if (self.myFeedManager.isFull == FALSE) {
//            _feedTableView.scrollEnabled = NO;
//            [self.view addSubview:activityIndicator];
//            [activityIndicator startAnimating];
//            [self performSelector:@selector(addMore) withObject:nil afterDelay:1.5];
//            _feedTableView.scrollEnabled = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self performSelector:@selector(addMore) withObject:nil afterDelay:1.5];
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                // Do something...
//                [self addMore];
//                NSLog(@"AddMore");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });

//            [self addMore];
        }
    }
}
#pragma mark - Navigation button action
- (void)logOut:(id)sender{
    NSLog(@"Logged out");
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.loginViewController];
}

@end
