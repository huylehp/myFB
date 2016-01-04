//
//  ScrollView.m
//  myFB
//
//  Created by AnLab Mac on 12/30/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "ScrollView.h"

@interface ScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *blackMask;
@end

@implementation ScrollView{
    CGRect oldImageFrame;
}
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize imageToView = _imageToView;
@synthesize blackMask = _blackMask;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Scroll View");
    if (_imageToView) {
        _imageView = [[UIImageView alloc] initWithImage:_imageToView];
        _imageView.center = self.view.center;
//        _imageView.image = _imageToView;
        oldImageFrame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView addSubview:_imageView];
        _scrollView.contentSize = _imageView.frame.size;
        
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:doubleTapRecognizer];
        //        self.scrollView.zoomScale = 3.0;
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        singleTapRecognizer.numberOfTouchesRequired = 1;
        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self.scrollView addGestureRecognizer:singleTapRecognizer];
//        [self centerScrollViewContents];
    } else {
        NSLog(@"No image to View");
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSLog(@"ViewWillAppear");
    self.scrollView.backgroundColor = [UIColor blackColor];
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];
    self.tabBarController.tabBar.hidden = YES;
//    [self centerScrollViewContents];
}
- (void)viewWillLayoutSubviews{
    
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    if (currentView.size.height < self.view.frame.size.height) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            NSLog(@"ContentSize:height %f ,width %f ", scrollView.contentSize.height, scrollView.contentSize.width);
            [self centerScrollViewContents];
            
//            CGFloat newY =
//            CGRect newView = CGRectMake(_imageView.frame.origin.x, , <#CGFloat width#>
            
        } completion:nil];
        
}
//- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    NSLog(@"ViewForZooming");
//    return _imageView;
//}

- (void)centerContent {
    CGFloat top = 0, left = 0;
    if (_scrollView.contentSize.width < _scrollView.bounds.size.width) {
        left = (_scrollView.bounds.size.width-_scrollView.contentSize.width) * 0.5f;
    }
    if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
        top = (_scrollView.bounds.size.height-_scrollView.contentSize.height) * 0.5f;
    }
    NSLog(@"left: %f, top: %f", left, top);
    _scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}
- (void) viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewSingleTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.navigationController.navigationBar.isHidden == YES ) {
        if (self.scrollView.zoomScale == 1.0) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
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
//        CGRect newViewFrame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
//        _imageView.frame = newViewFrame;
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
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
    }
    else {
        NSLog(@"Transform scale ");
//        CGRect newViewFrame = CGRectMake(oldImageFrame.origin.x, oldImageFrame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
//        _imageView.frame = newViewFrame;
        CGFloat newZoomScale = _scrollView.minimumZoomScale;
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w/ 2.0f);
        CGFloat y = pointInView.y - (h/ 2.0f);
        
        CGRect rectToZoomOut = CGRectMake(x, y, w, h);
        
        [self.scrollView zoomToRect:rectToZoomOut animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.view.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
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
    _imageView.frame = contentsFrame;
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
