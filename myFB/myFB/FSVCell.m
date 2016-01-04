//
//  FSVCell.m
//  myFB
//
//  Created by AnLab Mac on 12/10/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "FSVCell.h"

@implementation FSVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUpCellWithFeed:(Feed *)f andUser:(User *)user withTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    self.userImage.image = user.avatar;
    if (f.story) {
        self.userName.text = f.story;
    } else {
        self.userName.text = user.userName;
    }
    self.timeLabel.text = [f modifyTimeOfFeed];
    //    [f retrivePostTime:f.time];
    if (f.message) {
        self.userMessage.text = f.message;
    } else {
        self.userMessage.text = nil;
    }
    if (f.full_picture) {
        self.feedImage.backgroundColor = [UIColor blackColor];
        if (!(f.image)) {
            self.feedImage.image = [UIImage imageNamed:@"WaitScreen.png"];
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
            self.feedImage.image = [self imageWithImage:f.image scaledToWidth:tableView.frame.size.width];
        }
        
    } else {
        self.feedImage.image = nil;
    }
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
@end
