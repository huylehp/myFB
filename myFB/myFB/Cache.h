//
//  Cache.h
//  myFB
//
//  Created by AnLab Mac on 11/24/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUCacheItem.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h> 

@interface Cache : NSObject

+ (SUCacheItem *)getCacheItem;
+ (void) saveCacheItem:(SUCacheItem *)item;
+ (void) deleteCacheItem;
+ (void) clearCache;
@end
