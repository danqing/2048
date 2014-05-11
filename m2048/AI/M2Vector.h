//
//  M2Vector.h
//  m2048
//
//  Created by Sihao Lu on 4/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define M2VectorDown [[M2Vector alloc] initWithX:1 y:0]
#define M2VectorUp [[M2Vector alloc] initWithX:-1 y:0]
#define M2VectorLeft [[M2Vector alloc] initWithX:0 y:-1]
#define M2VectorRight [[M2Vector alloc] initWithX:0 y:1]

#define M2Vectors @[M2VectorDown, M2VectorUp, M2VectorLeft, M2VectorRight]

@interface M2Vector : NSObject

@property (nonatomic) NSInteger x, y;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;

- (NSString *)vectorString;

@end
