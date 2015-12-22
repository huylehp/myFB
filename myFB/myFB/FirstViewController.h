//
//  FirstViewController.h
//  myFB
//
//  Created by AnLab Mac on 11/25/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

//@class SecondViewController;
@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SecondVCDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *feedArrays;

@end
