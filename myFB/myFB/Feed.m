//
//  Feed.m
//  myFB
//
//  Created by AnLab Mac on 11/17/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "Feed.h"
#define WIDTH 320

@interface Feed ()
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end
@implementation Feed

-(void)setMessage:(NSString *)message Picture:(NSString *)picture Caption:(NSString *)caption AndLink:(NSString *)link Story:(NSString *)story Time:(NSString *)time
{
    self.message = message;
    self.full_picture = picture;
    self.caption = caption;
    self.link = link;
    self.story = story;
    self.time = time;
}
- (BOOL)hasImage
{
    return _image != nil;
}
- (BOOL)isFailed
{
    return _failed;
}
-(void)print
{
    NSLog(@"Message: %@",self.message);
    NSLog(@"Full_picture: %@", self.full_picture);
    NSLog(@"Caption: %@", self.caption);
    NSLog(@"Link: %@", self.link);
    NSLog(@"Story: %@", self.story);
    NSLog(@"Time: %@", self.time);
}
+ (CGSize)getResizeOfFullImage:(UIImage *)oriImage
{
    CGSize size ;
    size.width = WIDTH;
    size.height = oriImage.size.height * (WIDTH / oriImage.size.width);
    return size;
}
+ (void)downloadFeedImagesWithFeed:(Feed *)myFeed
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:myFeed.full_picture]];
    if (imageData) {
        UIImage *downloadImage = [UIImage imageWithData:imageData];
        myFeed.image = downloadImage;
    } else {
        myFeed.failed = YES;
        myFeed.image = [UIImage imageNamed:@"WaitScreen.png"];
    }
}
- (void)downloadFeedImagesWithFeed:(NSIndexPath *)indexPath andTable:(UITableView *)tableView WithBlockOfRatio:(void (^)(UIImage *image, CGFloat ratio, BOOL success))block
{
    if (self.hasImage) {
        //reload cell
        
        return;
    }
    
    if(isDownload && !self.hasImage){
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.full_picture]];
        self.image = [[UIImage alloc] initWithData:imageData];
//        self.image = [self imageAfterResizeFullPictureImage:[[UIImage alloc] initWithData:imageData] WithWidth:tableView.frame.size.width];
        self.ratio = self.image.size.width / self.image.size.height;
        if (self.ratio > 0.0) {
            block(self.image,self.ratio, TRUE);
        } else {
            block(nil,0.0, FALSE);
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
//            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
    
    isDownload = true;
}
- (void)startDownloadImageWithTableView:(UITableView *)tableView WithCompletion:(void (^)(UIImage *image, BOOL success)) block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.full_picture]];
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (error != nil) {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                NSLog(@"Cannot download ava");
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImage *image = [[UIImage alloc] initWithData:data];
//            UIImage *resizedImage = [self imageAfterResizeFullPictureImage:image WithWidth:tableView.frame.size.width];
            self.image = image;
        }];
    }];
    [self.sessionTask resume];
}
- (UIImage *)imageAfterResizeFullPictureImage:(UIImage *)image WithWidth:(CGFloat)width
{
//    CGRect rect = CGRectMake(0,0,75,75);
//    UIGraphicsBeginImageContext( rect.size );
//    [yourCurrentOriginalImage drawInRect:rect];
//    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSData *imageData = UIImagePNGRepresentation(picture1);
//    UIImage *img=[UIImage imageWithData:imageData];
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat newHeight = imageHeight * ( width / imageWidth);
    CGRect rect = CGRectMake(0, 0, width, newHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(img);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
- (void)getRatioWithBlock:(void (^)(CGFloat ratio, BOOL success))block{
    CGFloat ratio = 0.0;
    if (self.image) {
        ratio = self.image.size.width / self.image.size.height;
        block(ratio, YES);
    } else {
        block(ratio, NO);
    }
}
- (NSString *)modifyTimeOfFeed
{
    NSString *newTime = nil;

    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date = [df dateFromString:self.time];
    [df setDateFormat:@"eee MMM dd, yyyy hh:mm"];
    newTime = [df stringFromDate:date];
    return newTime;
}
-(NSString*)retrivePostTime:(NSString*)postDate{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *userPostDate = [df dateFromString:postDate];
    NSLog(@"userDate: %@", userPostDate);
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth ago",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd ago",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh ago",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm ago",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds ago",(long)[conversionInfo second]];
    }
    return returnDate;
}
@end
