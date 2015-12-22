//
//  Paging.m
//  myFB
//
//  Created by AnLab Mac on 11/18/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "Paging.h"

@implementation Paging
- (void)setPrevious:(NSString *)previous AndNext:(NSString *)next
{
    self.previous = previous;
    self.next = next;
}
- (void)printPagingInfo
{
    NSLog(@"previous: %@ and next: %@", self.previous, self.next);
}
@end
