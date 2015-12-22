//
//  Paging.h
//  myFB
//
//  Created by AnLab Mac on 11/18/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paging : NSObject
@property (strong, nonatomic) NSString * previous;
@property (strong, nonatomic) NSString * next;

- (void) setPrevious:(NSString *)previous AndNext:(NSString *)next;
- (void) printPagingInfo;
@end
