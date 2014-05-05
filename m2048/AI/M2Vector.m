//
//  M2Vector.m
//  m2048
//
//  Created by Sihao Lu on 4/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Vector.h"

@implementation M2Vector

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

@end
