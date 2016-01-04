//
//  FirstSubViewController.h
//  myFB
//
//  Created by AnLab Mac on 12/10/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface FirstSubViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SecondVCDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSMutableArray * feedArrays;

@end
