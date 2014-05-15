//
//  M2GlobalState+AI.m
//  m2048
//
//  Created by Sihao Lu on 5/5/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2GlobalState+AI.h"

@implementation M2GlobalState (AI)

- (NSInteger)maximumSearchingDepth {
    return 3;
}

- (NSTimeInterval)searchingTimeOut {
    return 5;
}

- (NSString *)AIAutoRunningCompleteNotificationName {
    return @"M2AIAutoRunningCompleteNotification";
}

- (NSString *)AIHintNotificationName {
    return @"M2AIHintNotification";
}

- (NSString *)AIAutoRunningStepNotificationName {
    return @"M2AIAutoRunningStepNotification";
}

@end
