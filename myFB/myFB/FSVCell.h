//
//  FSVCell.h
//  myFB
//
//  Created by AnLab Mac on 12/10/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "User.h"
@interface FSVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userMessage;
@property (weak, nonatomic) IBOutlet UIImageView *feedImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setUpCellWithFeed:(Feed *)feed andUser:(User *)user withTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
