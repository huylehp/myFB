//
//  SecondViewController.m
//  myFB
//
//  Created by AnLab Mac on 11/25/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "SecondViewController.h"
#import "UploadManager.h"
#import "FeedManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "User.h"
#import "MBProgressHUD.h"
@interface SecondViewController ()
@property(nonatomic, strong) NSArray *assets;
@property(nonatomic, strong) UploadManager *uploadManager;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;
@property(nonatomic, strong) UIBarButtonItem *postButton;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIImage *avatar;
@property(nonatomic, strong) NSString *placeHolder;
@end

@implementation SecondViewController{
    UIImage *imageToShow;
    BOOL _isHasImage;
    BOOL _isEdit;
    BOOL _isDownload;
    BOOL _isContentGenerated;
}
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the second Tab");
    
    if (self) {
        self.title = @"Update Status";
        self.tabBarItem.image = [UIImage imageNamed:@"picture-3-24.png"];
        self.uploadManager = [[UploadManager alloc] init];
        self.uploadManager.delegate = self;
        //Cancel button
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        //Post button
        self.postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postClicked:)];
        [self.navigationItem setRightBarButtonItem:self.postButton animated:YES];
        [self.postButton setEnabled:NO];
        _isDownload = FALSE;
        _isEdit = FALSE;
        _isHasImage = FALSE;
        self.placeHolder = [NSString stringWithFormat:@"What is your mind?"];
    }
    return self;
}

- (void)cancelButtonClicked{
    [self refreshView];
    [self.tabBarController setSelectedIndex:0];
}
- (void)refreshView{
    if (_isHasImage) {
        _isHasImage = FALSE;
    }
    if (self.showImage.image) {
        self.showImage.image = nil;
        //        [self.showImage setHidden:YES];
    }
    if (_isEdit) {
        _isEdit = FALSE;
    }
    [self textViewDidEndEditing:self.messageTextView];
    if (self.closeButton) {
        [self.closeButton removeFromSuperview];
        self.closeButton = nil;
    }
    [self checkPostButton];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    if (_isDownload) {
        self.avaImageView.image = self.avatar;
    } else {
        [self showAvaInTextView];
    }
    
//    [self showAvaInTextView];
//    isHasImage = FALSE;
    //just display some text so that we know what view we are in
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View is displayed for the second Tab");
//    [self showAvaInTextView];
//    [self performSelector:@selector(showAvaInTextView) withObject:nil afterDelay:1.0];
    NSLog(@"Feed");
}

- (void) showAvaInTextView{
    __block User *myUser = [[User alloc] init];
    [myUser getUserProfileWithCompletionBlock:^(BOOL success, User *user) {
        if (success) {
            myUser = user;
            if (myUser.userImage) {
                [myUser downloadAvatarWithURLString:myUser.userImage withCompletion:^(UIImage *image, BOOL success) {
                    if (success == FALSE) {
                        NSLog(@"Error download");
                    } else {
                        self.avatar = [[UIImage alloc] init];
                        self.avatar = image;
                        _isDownload = YES;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            /* Do UI work here */
//                            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
//                            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//                            textAttachment.image = image;
//                            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//                            [attributedString replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:attrStringWithImage];
//                            self.messageTextView.attributedText = attrStringWithImage;
//                            [self.messageTextView setNeedsDisplay];
                            self.avaImageView.image = image;
                            NSLog(@"size: %@", NSStringFromCGSize(self.avaImageView.image.size));
                        });

                    }
                }];
            } else {
                NSLog(@"No userImage");
            }
        }
    }];
}


#pragma mark - TextView delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = self.placeHolder;
        [textView resignFirstResponder];
        _isEdit = FALSE;
    } else {
        _isEdit = TRUE;
    }
    [self checkPostButton];
}

- (void)checkPostButton{
    if (_isEdit || _isHasImage) {
        [self.postButton setEnabled:YES];
    } else {
        [self.postButton setEnabled:NO];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_isEdit == TRUE) {
        
    } else {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"End");
    if ([textView.text isEqual:@""] || _isEdit == NO) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = self.placeHolder;
    }
//    [textView setNeedsDisplay];
}
- (void)processCompleted{
    NSLog(@"Completed");
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

- (IBAction)postClicked:(id)sender {
    if (_isHasImage == FALSE) {
        NSLog(@"Have no image");
        NSString *messageToPost = self.messageTextView.text;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([FBSDKAccessToken currentAccessToken]) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me/feed"
                                          parameters:@{ @"message": messageToPost,}
                                          HTTPMethod:@"POST"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    NSLog(@"Error to post a message");
                } else {
                    NSLog(@"Posted");
                    [self refreshView];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.tabBarController setSelectedIndex:0];
                    [self.delegate delegateMethod:@"Uploaded!"];
                }
            }];
        }
    } else {
        UIImage *imageToUpload = [[UIImage alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self refreshView];
        imageToUpload = [self imageWithImage:imageToShow scaledToWidth:self.view.bounds.size.width];
        [self.uploadManager uploadImage:imageToUpload withCaption:self.messageTextView.text];
    }

    
}
- (void)updateHasBeenDone{
    NSLog(@"Done");

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tabBarController setSelectedIndex:0];
    [self.delegate delegateMethod:@"Uploaded!"];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.messageTextView endEditing:YES];
}
- (IBAction)takePicture:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)goToAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (chosenImage) {
        _isHasImage = TRUE;
    }

    //Show image in textview
    [self showImageWithInfo:info];
    //Save image in file to upload
    [self checkPostButton];
    
//    [self.uploadManager uploadImage:chosenImage withCaption:@"Picture of Album"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)showImageWithInfo: (NSDictionary *)info{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            imageToShow = nil;
            imageToShow = image;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.showImage.contentMode = UIViewContentModeScaleAspectFit;
                self.showImage.image = imageToShow;
                [self addClose];
                self.showImage.userInteractionEnabled = YES;
            } completion:nil];

        });
    });
}
- (void)addClose{
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    //                button.backgroundColor = [UIColor whiteColor];
    [self.closeButton setImage:[UIImage imageNamed:@"x-mark-50.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.showImage addSubview:self.closeButton];
}
- (void)buttonClicked{
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
    self.showImage.image = nil;
    _isHasImage = FALSE;
    [self checkPostButton];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - ScaleImage
- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float _newHeight = sourceImage.size.height * scaleFactor;
    float _newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(_newWidth, _newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, _newWidth, _newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
