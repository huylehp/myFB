//
//  ImageScrollViewController.h
//  myFB
//
//  Created by AnLab Mac on 12/14/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *messageNav;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *imageToView;
@property (strong, nonatomic) NSString *message;
@end
