//
//  M2AI.h
//  m2048
//
//  Created by Sihao Lu on 4/19/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2Grid+AI.h"

@class M2Grid;
@interface M2AI : NSObject

- (instancetype)initWithGrid:(M2Grid *)grid;

@end

@interface M2AIResult : NSObject

@property M2Vector *move;

@property double score;

@property NSInteger positions;

@property NSInteger cutoffs;

- (id)initWithMove:(M2Vector *)bestMove score:(double)score positions:(NSInteger)positions cutoffs:(NSInteger)cutoffs;

@end
