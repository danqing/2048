//
//  M2GlobalState+AI.h
//  m2048
//
//  Created by Sihao Lu on 5/5/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2GlobalState.h"

@interface M2GlobalState (AI)

- (NSInteger)maximumSearchingDepth;

- (NSTimeInterval)searchingTimeOut;

- (NSString *)AIAutoRunningCompleteNotificationName;

- (NSString *)AIHintNotificationName;

@end
