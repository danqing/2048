//
//  M2Grid+AI.h
//  m2048
//
//  Created by Sihao Lu on 4/19/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Grid.h"

@class M2Vector;
@interface M2Grid (AI)

- (double)monotonicity;

/**
 * Measures how smooth the grid is (as if the values of the pieces
 * were interpreted as elevations). Sums of the pairwise difference
 * between neighboring tiles (in log space, so it represents the
 * number of merges that need to happen before they can merge).
 * @return Smoothness.
 * @note The pieces can be distant.
 */

- (NSInteger)smoothness;

- (NSInteger)maxLevel;

- (double)heuristicValue;

- (M2Grid *)gridAfterMoveWithDirection:(M2Vector *)direction;

- (BOOL)isWinningBoard;

- (BOOL)isGameOver;

/**
 *  For debugging purpose only.
 */
- (void)dumpGrid;

@end
