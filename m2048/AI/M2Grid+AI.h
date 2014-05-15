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

/**
 *  Initialize a new grid with given raw grid described with a two-dimensional array.
 *
 *  @param grid The raw grid.
 *  @return A new instance of `M2Grid` object.
 *  @note The elements in grid must be the levels, instead of real values.
 */
- (instancetype)initWithRawGrid:(NSArray *)grid;

/**
 *  Measures if the tiles in the grid is decreasing monotonically.
 *  @return The monotonicity.
 */
- (double)monotonicity;

/**
 * Measures how smooth the grid is (as if the values of the pieces
 * were interpreted as elevations). Sums of the pairwise difference
 * between neighboring tiles (in log space, so it represents the
 * number of merges that need to happen before they can merge).
 * @return The Ssmoothness.
 * @note The pieces can be distant.
 */

- (NSInteger)smoothness;

- (NSInteger)maxLevel;

- (double)heuristicValue;

- (M2Grid *)gridAfterMoveInDirection:(M2Vector *)direction;

- (BOOL)isMovableInDirection:(M2Vector *)direction;

- (BOOL)isWinningBoard;

- (BOOL)isGameOver;

/**
 *  For debugging purpose only.
 */
- (void)dumpGrid;

@end
