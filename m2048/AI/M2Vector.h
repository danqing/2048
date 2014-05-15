//
//  M2Vector.h
//  m2048
//
//  Created by Sihao Lu on 4/30/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define M2VectorDown [M2Vector downVector]
#define M2VectorUp [M2Vector upVector]
#define M2VectorLeft [M2Vector leftVector]
#define M2VectorRight [M2Vector rightVector]

#define M2Vectors @[M2VectorDown, M2VectorUp, M2VectorLeft, M2VectorRight]

@interface M2Vector : NSObject

@property (nonatomic) NSInteger x, y;

- (NSString *)vectorString;

+ (M2Vector *)downVector;

+ (M2Vector *)upVector;

+ (M2Vector *)leftVector;

+ (M2Vector *)rightVector;

@end
