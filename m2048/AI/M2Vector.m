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

- (NSString *)vectorString {
    if ([self isEqual:M2VectorUp]) return @"Up";
    if ([self isEqual:M2VectorDown]) return @"Down";
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
