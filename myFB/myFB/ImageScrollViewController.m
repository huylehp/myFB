//
//  ImageScrollViewController.m
//  myFB
//
//  Created by AnLab Mac on 12/14/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "ImageScrollViewController.h"

@interface ImageScrollViewController (){
    UIView *_blackMask;
}

@end

@implementation ImageScrollViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.message) {
        self.messageNav.topItem.title = self.message;
    }
    else {
        self.messageNav.topItem.title = nil;
    }
    if (self.imageToView) {
//        self.imageView = [[UIImageView alloc] initWithImage:self.imageToView];
//        self.imageView.frame = CGRectMake(0.0, 0.0, self.imageToView.size.width, self.imageToView.size.height);
//        [self.scrollView addSubview:self.imageView];
//        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.contentSize = self.imageToView.size;
        self.imageView.image = self.imageToView;
//        self.imageView.contentMode = UIViewContentModeCenter;
        if (self.imageView.bounds.size.width < self.imageToView.size.width || self.imageView.bounds.size.height < self.imageToView.size.height) {
            NSLog(@"Yes");
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            NSLog(@"No");
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:doubleTapRecognizer];
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.maximumZoomScale = 5.0;
//        self.scrollView.zoomScale = 3.0;
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        singleTapRecognizer.numberOfTouchesRequired = 1;
        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];        
        [self.scrollView addGestureRecognizer:singleTapRecognizer];
        //
//        UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
//        twoFingerTapRecognizer.numberOfTapsRequired = 1;
//        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
//        [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    }
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillLayoutSubviews{
//    self.imageView.center = self.view.center;
}
- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
//    [self.navigationController setHidesBarsOnTap:YES];
//    CGRect scrollViewFrame = self.scrollView.frame;
//    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
//    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
//    CGFloat minScale = MIN(scaleHeight, scaleWidth);
//    self.scrollView.minimumZoomScale = minScale;
//    
//    self.scrollView.maximumZoomScale = 1.0f;
//    self.scrollView.zoomScale = minScale;
//
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];

//    [self centerScrollViewContents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Selector Scroll
- (void)scrollViewSingleTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.navigationController.navigationBar.isHidden == YES ) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    NSLog(@"zoomScale: %f", self.scrollView.zoomScale);
    if (self.scrollView.zoomScale == 1.0) {
        // 2
        CGFloat newZoomScale = 5.0;
        //    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        
        // 3
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    }
    else {
        NSLog(@"Transform scale ");
        CGFloat newZoomScale = 1.0;

        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x / 2.0f;
        CGFloat y = pointInView.y / 2.0f;
        
        CGRect rectToZoomOut = CGRectMake(x, y, w, h);
        
        [self.scrollView zoomToRect:rectToZoomOut animated:YES];
    }
}
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer
{
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}
- (void) centerScrollViewContents{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}
#pragma mark - Scroll View Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    NSLog(@"Back button");
    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
