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
    CGFloat offsetY;
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
        [self setUpImageToView];

        [self setUpGesture];
        [self centerScrollViewContents];
        offsetY = self.imageView.frame.origin.y;
    }
    // Do any additional setup after loading the view from its nib.

}
- (void)setUpImageToView
{
    [_imageView removeFromSuperview];
    _imageView = nil;
    NSLog(@"Width: %f", self.view.frame.size.width);
    _imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:_imageToView scaledToWidth:self.view.bounds.size.width]];
    _scrollView.contentSize = _imageView.image.size;
    [_scrollView addSubview:_imageView];

}
- (void)setUpGesture
{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    //        self.scrollView.zoomScale = 3.0;
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"Did rotated");
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setUpImageToView];
        NSLog(@"Image Size: %@",NSStringFromCGSize(_imageView.intrinsicContentSize));
        NSLog(@"Content Size: %@",NSStringFromCGSize(_scrollView.contentSize));
        [self centerScrollViewContents];
    } completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSLog(@"ViewWillAppear");
    //Animation
    
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];

//    [self centerScrollViewContents];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void) viewWillLayoutSubviews
{
    NSLog(@"viewWillLayout");
    [self setUpImageToView];
    NSLog(@"Image Size: %@",NSStringFromCGSize(_imageView.intrinsicContentSize));
    NSLog(@"Content Size: %@",NSStringFromCGSize(_scrollView.contentSize));
    [self centerScrollViewContents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Selector Scroll
- (void)scrollViewSingleTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.navigationController.navigationBar.isHidden == YES ) {
        if (self.scrollView.zoomScale == 1.0) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.tabBarController.tabBar setHidden:NO];
        }
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.tabBarController.tabBar setHidden:YES];
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
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.tabBarController.tabBar setHidden:YES];
    }
    else {
        NSLog(@"Transform scale ");
        CGFloat newZoomScale = 1.0;

        CGSize scrollViewSize = self.scrollView.bounds.size;
        NSLog(@"ScrollViewSize: %@", NSStringFromCGSize(self.scrollView.bounds.size));
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w/ 2.0f);
        CGFloat y = pointInView.y - (h/ 2.0f);
        
        CGRect rectToZoomOut = CGRectMake(x, y, w, h);
        
        [self.scrollView zoomToRect:rectToZoomOut animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.tabBarController.tabBar setHidden:NO];
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
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else {
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"Scroll");
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self centerScrollViewContents];
//    } completion:nil];

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
