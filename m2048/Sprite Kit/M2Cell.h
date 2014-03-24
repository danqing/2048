//
//  M2Cell.h
//  m2048
//
//  Created by Danqing on 3/17/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class M2Tile;

@interface M2Cell : NSObject

/** The position of the cell. */
@property (nonatomic) M2Position position;

/** The tile in the cell, if any. */
@property (nonatomic, strong) M2Tile *tile;

/**
 * Initialize a M2Cell at the specified position with no tile in it.
 *
 * @param position The position of the cell.
 */
- (instancetype)initWithPosition:(M2Position)position;

@end
