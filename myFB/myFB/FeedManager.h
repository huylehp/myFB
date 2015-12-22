//
//  FeedManager.h
//  myFB
//
//  Created by AnLab Mac on 12/22/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Feed.h"
#import "Paging.h"
@class FeedManager;
@protocol FeedDelegate <NSObject>
- (void) arrayImageOfFeed: (NSMutableArray *)arrayOfImage;
@end
@interface FeedManager : NSObject
{
    NSMutableDictionary *shareFeed;
    
}
@property (nonatomic, weak) id <FeedDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary * shareFeed;
@property (nonatomic, strong) NSMutableArray * arrayOfPagings;
@property (nonatomic, strong) NSMutableArray * arrayOfFeeds;
@property (nonatomic, strong) Paging *paging;
@property (nonatomic) Boolean isFull;
@property (nonatomic) Boolean isDownload;
//@property (nonatomic, retain) NSString * someProperty;
+ (id)sharedManager;

- (void)takingArrayOfFeedWithSuccess:(void (^)(NSMutableArray * result))   success
                             failure:(void (^)(NSError * error))           failure;
- (void)createFeedManagerWithSuccess:(void (^)(NSMutableArray *feedArrays, Paging * paging))success failure:(void (^)(NSError *error)) failure;
- (NSUInteger) sizeOfFeeds;
- (void) addFeed: (Feed *)feed;
- (void) listOfFeeds;
- (void) getArrayOfPaging;
- (void) addPaging:(Paging *)page;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSizeOfWidtd:(CGFloat)width;
- (void) downloadFeedImagesAtIndexPath:(NSIndexPath *) indexPath;
- (void)makeFBRequestToPath:(NSString *)aPath withParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
- (void) addMoreFeedFromPath:(NSString *)path WithPagingString:(NSString *)paging storage:(NSMutableArray *)feedArrays success:(void (^) (NSArray *))success failure:(void (^)(NSError *))failure;
- (void)pagingMoreNewFeedWithPagingString:(NSString *)paging withCompletionSuccess:(void (^) (NSArray *))success failure:(void (^)(NSError *))failure;
@end