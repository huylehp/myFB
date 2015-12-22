//
//  FeedManager.m
//  myFB
//
//  Created by AnLab Mac on 12/22/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "FeedManager.h"

@implementation FeedManager

@synthesize shareFeed, arrayOfPagings,arrayOfFeeds;

#pragma mark - Singleton
+ (id)sharedManager; {
    static FeedManager *shareMyFeed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMyFeed = [[self alloc] init];
    });
    
    return shareMyFeed;
}
- (id) init
{
    if (self == [super init]) {
        shareFeed = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) singleton
{
    NSLog(@"%@", self.shareFeed);
}

#pragma mark - Table view data source
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSizeOfWidtd:(CGFloat)width{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    CGSize newSize;
    newSize.width = width;
    newSize.height = (newSize.width / image.size.width) * image.size.height;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)addFeed:(Feed *)feed
{
    [self.arrayOfFeeds addObject:feed];
}

- (void)takingArrayOfFeedWithSuccess:(void (^)(NSMutableArray * result))   success
                             failure:(void (^)(NSError * error))      failure
{
    NSLog(@"Start take");
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"token");
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/feed"
                                      parameters:@{ @"fields": @"full_picture,created_time,story,link,caption,message",@"limit": @"10",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Insert your code here
            if (error) {
                NSLog(@"tokenAccess error");
            } else {
                shareFeed = result;
                arrayOfFeeds = [NSMutableArray array];
                for (NSUInteger i = 0; i < [result[@"data"] count]; i++) {
                    Feed * myFeed = [[Feed alloc] init];
                    [myFeed setMessage:result[@"data"][i][@"message"]
                               Picture:result[@"data"][i][@"full_picture"]
                               Caption:result[@"data"][i][@"caption"]
                               AndLink:result[@"data"][i][@"link"]
                                 Story:result[@"data"][i][@"story"]
                                  Time:result[@"data"][i][@"created_time"]];
                    Paging *paging = [[Paging alloc] init];
                    paging.previous = result[@"paging"][@"previous"];
                    paging.next = result[@"paging"][@"next"];
                    self.paging = paging;
                    if (paging.next == nil) {
                        self.isFull = TRUE;
                    } else {
                        self.isFull = FALSE;
                    }
                    [self addFeed:myFeed];
                }
                if (arrayOfFeeds != nil) {
                    NSMutableArray *result = arrayOfFeeds;
                    if (success) {
                        success(result);
                    }
                } else{
                    NSError *error = nil;
                    if (failure) {
                        failure(error);
                    }
                }
            }
        }];
    }
}
- (void)createFeedManagerWithSuccess:(void (^)(NSMutableArray *feedArrays, Paging * paging))success failure:(void (^)(NSError *error)) failure{
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/feed"
                                      parameters:@{ @"fields": @"full_picture,created_time,story,link,caption,message",@"limit": @"10",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"tokenAccess error");
            } else {
                arrayOfFeeds = [NSMutableArray array];
                //                NSLog(@"result: %@", result);
                for (NSUInteger i = 0; i < [result[@"data"] count]; i++) {
                    Feed * myFeed = [[Feed alloc] init];
                    [myFeed setMessage:result[@"data"][i][@"message"]
                               Picture:result[@"data"][i][@"full_picture"]
                               Caption:result[@"data"][i][@"caption"]
                               AndLink:result[@"data"][i][@"link"]
                                 Story:result[@"data"][i][@"story"]
                                  Time:result[@"data"][i][@"created_time"]];
                    [self addFeed:myFeed];
                }
                Paging *paging = [[Paging alloc] init];
                paging.previous = result[@"paging"][@"previous"];
                paging.next = result[@"paging"][@"next"];
                self.paging = paging;
                if (paging.next == nil) {
                    self.isFull = TRUE;
                } else {
                    self.isFull = FALSE;
                }
                if (arrayOfFeeds != nil) {
                    NSMutableArray *result = arrayOfFeeds;
                    if (success) {
                        success(result, self.paging);
                    }
                } else{
                    NSError *error = nil;
                    if (failure) {
                        failure(error);
                    }
                }
            }
        }];
    }
}
- (NSUInteger) sizeOfFeeds
{
    return [arrayOfFeeds count];
}
- (void) listOfFeeds
{
    NSLog(@"list:");
    for (NSUInteger i = 0; i < self.sizeOfFeeds; i++) {
        NSLog(@"Feed : %d", i);
        NSLog(@"Message: %@ \nFull picture: %@ \nCaption: %@ \nLink: %@", [arrayOfFeeds[i] message],[arrayOfFeeds[i] full_picture], [arrayOfFeeds[i] caption], [arrayOfFeeds[i] link] );
    }
}

#pragma mark - Paging
- (void)addPaging:(Paging *)page
{
    [self.arrayOfPagings addObject:page];
}
- (void)getArrayOfPaging{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/feed" parameters:@{@"fields":@"full_picture, message, caption, link"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"tokenAccess error");
            } else {
                Paging *myPaging = [[Paging alloc] init];
                [myPaging setPrevious:result[@"paging"][@"previous"] AndNext:result[@"paging"][@"next"]];
                [myPaging printPagingInfo];
                [self addPaging: myPaging];
                
            }
        }];
        
    }
}
- (void)makeFBRequestToPath:(NSString *)aPath withParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //create array to store results of multiple requests
    NSMutableArray *recievedDataStorage = [NSMutableArray new];
    
    //run requests with array to store results in
    [self p_requestFromPath:aPath parameters:parameters storage:recievedDataStorage success:success failure:failure];
}


- (void)p_requestFromPath:(NSString *)path parameters:(NSDictionary *)params storage:(NSMutableArray *)feeds success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //create requests with needed parameters
    FBSDKGraphRequest *fbRequest = [[FBSDKGraphRequest alloc]initWithGraphPath:path
                                                                    parameters:params
                                                                    HTTPMethod:nil];
    
    //then make a Facebook connection
    FBSDKGraphRequestConnection *connection = [FBSDKGraphRequestConnection new];
    [connection addRequest:fbRequest
         completionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary*result, NSError *error) {
             
             //if error pass it in a failure block and exit out of method
             if (error){
                 if(failure){
                     failure(error);
                 }
                 return ;
             }
             //add recieved data to array
             [feeds addObjectsFromArray:result[@"data"]];
             //then get parameters of link for the next page of data
             NSDictionary *paramsOfNextPage = [FBSDKUtility dictionaryWithQueryString:result[@"paging"][@"next"]];
             if (paramsOfNextPage.allKeys.count > 0){
                 [self p_requestFromPath:path
                              parameters:paramsOfNextPage
                                 storage:feeds
                                 success:success
                                 failure:failure];
                 //just exit out of the method body if next link was found
                 return;
             }
             if (success){
                 success([feeds copy]);
             }
         }];
    //do not forget to run connection
    [connection start];
}
- (void) addMoreFeedFromPath:(NSString *)path WithPagingString:(NSString *)paging storage:(NSMutableArray *)feedArrays success:(void (^) (NSArray *))success failure:(void (^)(NSError *))failure{
    NSDictionary *paramOfNextPage = [FBSDKUtility dictionaryWithQueryString:paging];
    //    NSLog(@"%@", paramOfNextPage);
    FBSDKGraphRequest *fbRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:paramOfNextPage HTTPMethod:nil];
    FBSDKGraphRequestConnection *connection = [FBSDKGraphRequestConnection new];
    [connection addRequest:fbRequest completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        [feedArrays addObjectsFromArray:result[@"data"]];
        //        NSLog(@"result : %@", result);
        
        if (success) {
            success([feedArrays copy]);
        }
    }];
    [connection start];
}
- (void)pagingMoreNewFeedWithPagingString:(NSString *)paging withCompletionSuccess:(void (^) (NSArray *))success failure:(void (^)(NSError *))failure{
    NSDictionary *paramOfNextPage = [FBSDKUtility dictionaryWithQueryString:paging];
    //    NSLog(@"paging: %@", paging);
    NSLog(@"%@", paramOfNextPage);
    NSLog(@"paging_token:%@", paramOfNextPage[@"__paging_token"]);
    NSLog(@"until:%@", paramOfNextPage[@"until"]);
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/feed"
                                  parameters:@{ @"fields": @"full_picture,story,created_time,message,link,caption",@"limit": @"10",@"until": paramOfNextPage[@"until"],@"__paging_token": paramOfNextPage[@"__paging_token"],}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // Insert your code here
        if (error) {
            if (failure) {
                failure(error);
            }
            return ;
        }
        NSLog(@"paging result:%@", result);
        NSMutableArray *data = [NSMutableArray array];
        for (NSUInteger i = 0;i < [result[@"data"] count] ; i++) {
            Feed *myFeed = [[Feed alloc] init];
            [myFeed setMessage:result[@"data"][i][@"message"]Picture:result[@"data"][i][@"full_picture"] Caption:result[@"data"][i][@"caption"] AndLink:result[@"data"][i][@"link"] Story:result[@"data"][i][@"story"] Time:result[@"data"][i][@"created_time"]];
            [data addObject:myFeed];
        }
        Paging *paging = [[Paging alloc] init];
        paging.previous = result[@"paging"][@"previous"];
        paging.next = result[@"paging"][@"next"];
        self.paging = paging;
        //        NSLog(@"paging: %@", paging.next);
        if (paging.next == nil) {
            self.isFull = TRUE;
        } else {
            self.isFull = FALSE;
        }
        if (data != nil) {
            if (success) {
                success(data);
            }
        } else {
            NSError *error = nil;
            if (failure) {
                failure(error);
            }
        }
        
    }];
    
}
- (void) downloadFeedImagesAtIndexPath:(NSIndexPath *) indexPath
{
    Feed *currentFeed = [arrayOfFeeds objectAtIndex:indexPath.row];
    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentFeed.full_picture]];
    if (dataImage) {
        UIImage *downloadedImage = [UIImage imageWithData:dataImage];
        currentFeed.image = downloadedImage;
    } else {
        currentFeed.failed = YES;
        currentFeed.image = [UIImage imageNamed:@"WaitScreen.png"];
    }
    dataImage = nil;
}

#pragma mark - Interface Source
@end

