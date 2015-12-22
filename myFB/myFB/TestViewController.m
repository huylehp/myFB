//
//  TestViewController.m
//  myFB
//
//  Created by AnLab Mac on 12/1/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "TestViewController.h"
#import "User.h"
#import "FSVCell.h"
#import "FeedManager.h"
@interface TestViewController ()
@property (strong, nonatomic) FeedManager *feedManager;
@end

@implementation TestViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the first Tab");
    
    if (self) {
        //set the title for the tab
        self.title = @"Test";
        //set the image icon for the tab
        self.tabBarItem.image = [UIImage imageNamed:@"pages-2-24.png"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedArrays = [NSMutableArray array];
    self.feedManager = [[FeedManager alloc] init];
    [self.feedManager createFeedManagerWithSuccess:^(NSMutableArray *feedArrays, Paging *paging) {
        [self.feedArrays addObjectsFromArray:feedArrays];
        [self.feedManager pagingMoreNewFeedWithPagingString:self.feedManager.paging.next withCompletionSuccess:^(NSArray *success) {
            [self.feedArrays addObjectsFromArray:success];
        } failure:^(NSError *failure) {
            NSLog(@"%@", failure);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
