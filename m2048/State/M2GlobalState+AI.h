//
//  M2GlobalState+AI.h
//  m2048
//
//  Created by Sihao Lu on 5/5/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2GlobalState.h"

@interface M2GlobalState (AI)

- (NSString *)AIAutoRunningCompleteNotificationName;

- (NSString *)AIHintNotificationName;

- (NSString *)AIAutoRunningStepNotificationName;

@end
