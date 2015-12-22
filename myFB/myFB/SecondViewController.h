//
//  SecondViewController.h
//  myFB
//
//  Created by AnLab Mac on 11/25/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FirstViewController.h"
#import "UploadManager.h"
@class FirstViewController;
@protocol SecondVCDelegate <NSObject>

@required
- (void) delegateMethod:(NSString *)message;

@end

@interface SecondViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) NSMutableArray *photoArrays;
@property (weak, nonatomic) NSMutableArray *thumbArrays;
@property (nonatomic) BOOL isDone;
@property (nonatomic, weak) id <SecondVCDelegate> delegate;

- (IBAction)postClicked:(id)sender;
- (IBAction)photoClicked:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)goToAlbum:(id)sender;

@end
