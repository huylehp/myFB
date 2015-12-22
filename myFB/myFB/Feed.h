//
//  Feed.h
//  myFB
//
//  Created by AnLab Mac on 11/17/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Feed : NSObject{
    bool isDownload;
}

@property (strong, atomic) NSString * full_picture;
@property (strong, nonatomic) NSString * message;
@property (strong, nonatomic) NSString * caption;
@property (strong, nonatomic) NSString * link;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * story;
@property (nonatomic) CGFloat ratio;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, getter= isFailed) BOOL failed;
-(void) setMessage:(NSString *)message Picture:(NSString *)picture Caption:(NSString *)caption AndLink:(NSString *)link Story:(NSString *)story Time:(NSString *)time;
-(void) print;
+ (CGSize) getResizeOfFullImage:(UIImage *) oriImage;
- (void)downloadFeedImagesWithFeed:(NSIndexPath *)indexPath andTable:(UITableView *)tableView WithBlockOfRatio:(void(^)(UIImage *image, CGFloat ratio, BOOL success)) block;
- (UIImage *)imageAfterResizeFullPictureImage:(UIImage *)image WithWidth:(CGFloat)width;
- (void)getRatioWithBlock:(void(^)(CGFloat ratio, BOOL success)) block;
- (void)startDownloadImageWithTableView:(UITableView *)tableView WithCompletion:(void (^)(UIImage *image, BOOL success)) block;
- (NSString *)modifyTimeOfFeed;
-(NSString*)retrivePostTime:(NSString*)postDate;
@end
