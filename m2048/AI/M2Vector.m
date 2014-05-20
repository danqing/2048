//
//  M2Vector.m
//  m2048
//
//  Created by Sihao Lu on 4/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Vector.h"

M2Vector *up, *down, *left, *right;

@implementation M2Vector

+ (void)load {
    down = [[M2Vector alloc] initWithX:1 y:0];
    up = [[M2Vector alloc] initWithX:-1 y:0];
    left = [[M2Vector alloc] initWithX:0 y:-1];
    right = [[M2Vector alloc] initWithX:0 y:1];
}

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

+ (M2Vector *)downVector {
    return down;
}

+ (M2Vector *)upVector {
    return up;
}

+ (M2Vector *)leftVector {
    return left;
}

+ (M2Vector *)rightVector {
    return right;
}

- (NSString *)vectorString {
    if ([self isEqual:M2VectorUp]) return @"Down";
    if ([self isEqual:M2VectorDown]) return @"Up";
    if ([self isEqual:M2VectorLeft]) return @"Left";
    if ([self isEqual:M2VectorRight]) return @"Right";
    return @"(I don't know)";
}

#pragma mark - Equality
- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (!object || ![object isKindOfClass:[M2Vector class]]) return NO;
    M2Vector *vector = object;
    return self.x == vector.x && self.y == vector.y;
}

- (NSUInteger)hash {
    return 37 * _x + _y;
}

@end
