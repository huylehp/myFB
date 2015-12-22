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
@interface SecondViewController ()
@property(nonatomic, strong) NSArray *assets;
@property(nonatomic, strong) UploadManager *uploadManager;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation SecondViewController{
    UITableView *tableView;
    UILabel *myLabel;
    UIButton *uploadButton;
    UIImage *uploadImage;
    NSMutableArray *allPhotos;
    NSMutableDictionary *dic;
    NSInteger count;
}
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the second Tab");
    
    if (self) {
        self.title = @"Update";
        self.tabBarItem.image = [UIImage imageNamed:@"picture-3-24.png"];
//        [self addUploadButton];
        self.uploadManager = [[UploadManager alloc] init];
        self.uploadManager.delegate = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View is displayed for the second Tab");
//    [self addUploadButton];
    NSLog(@"Feed");

//    [self takePhotos];
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [SecondViewController defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [tmpAssets addObject:result];
            }
        }];
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        self.assets = tmpAssets;
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
    //just display some text so that we know what view we are in
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}
#pragma mark - TextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqual:@""]) {
        [self.statusButton setEnabled:NO];
    } else {
        [self.statusButton setEnabled:YES];
    }
}

#pragma mark - Upload Button
- (void)addUploadButton
{
    myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 100)];
    myLabel.text = @"Update Status";
    myLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [self.view addSubview:myLabel];
    uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
    uploadButton.backgroundColor = [UIColor lightGrayColor];
//    uploadButton.titleLabel.textColor = [UIColor orangeColor];
    [uploadButton setTitle:@"Upload" forState:UIControlStateNormal];
    uploadButton.center = self.view.center;
    [uploadButton addTarget:self action:@selector(uploadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];

}
- (void)processCompleted{
    NSLog(@"Completed");
}
- (void)uploadClicked
{
    NSLog(@"clicked");
//    UIImage *sampleImage = [UIImage imageNamed:@"myFB-logo.png"];
//    [uploadManager takeUploadImage:sampleImage];
//    [uploadManager uploadArrayOfUploadImages];
    [self.tabBarController setSelectedIndex:0];
//    FirstViewController *first = [[FirstViewController alloc] initWithNibName:nil bundle:NULL];
//    first.delegate = self;
//    [first startProcess];
    
}
- (void)takePhotos{
    self.photoArrays = [NSMutableArray array];
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSLog(@"result: %@", result);
                    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
                    ALAssetRepresentation *defaultRepresentation = [result defaultRepresentation];
                    NSString *uti = [defaultRepresentation UTI];
                    NSURL *photoURL = [[result valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                    NSString *title = [NSString stringWithFormat:@"photo %d", arc4random()%100];
                    UIImage *image = [UIImage imageWithCGImage:[defaultRepresentation fullScreenImage]];
                    NSLog(@"name: %@", image);
                    [dic1 setValue:title forKey:@"name"];
                    [dic1 setValue:photoURL forKey:@"url"];
                    [dic1 setValue:image forKey:@"image"];
                    [allPhotos addObject:dic];
                    NSLog(@"Size: %d", [allPhotos count]);
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error enumerating AssetLibrary groups %@\n", error);
    }];
}
#pragma mark - Collection View
+ (ALAssetsLibrary *)defaultAssetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
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
    NSString *messageToPost = self.messageTextView.text;
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
                [self.tabBarController setSelectedIndex:0];
                [self.delegate delegateMethod:@"Uploaded!"];
            }
        }];
    }
    
}

- (IBAction)photoClicked:(id)sender {
    UIImage *sample = [UIImage imageNamed:@"2w3536h.jpg"];
    [self.uploadManager uploadImage:sample withCaption:@"Blue sea"];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [self.spinner setCenter:CGPointMake(160,124)];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [self.tabBarController setSelectedIndex:0];
    [self.delegate delegateMethod:@"Uploaded!"];
}
- (void)updateHasBeenDone{
    NSLog(@"Done");
    [self.spinner removeFromSuperview];
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
    [self.uploadManager uploadImage:chosenImage withCaption:@"Picture of Album"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
