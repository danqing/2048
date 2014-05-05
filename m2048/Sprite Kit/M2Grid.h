//
//  M2Grid.h
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2Cell.h"

@class M2Scene;

typedef void (^IteratorBlock)(M2Position);


@interface M2Grid : NSObject <NSCopying>

/** The dimension of the grid. */
@property (nonatomic, readonly) NSInteger dimension;

/** The scene in which the game happens. */
@property (nonatomic, weak) M2Scene *scene;


/**
 * Initializes a new grid with the given dimension.
 *
 * @param dimension The desired dimension, i.e. # cells in a row or column.
 */
- (instancetype)initWithDimension:(NSInteger)dimension;

/**
 *  Initialize a new grid with given raw grid described with a two-dimensional array.
 *
 *  @param grid The raw grid.
 *  @return A new instance of `M2Grid` object.
 *  @note The elements in grid must be the levels, instead of real values.
 */
- (instancetype)initWithRawGrid:(NSArray *)grid;

/**
 * Iterates over the grid and calls the block, which takes in the M2Position
 * of the current cell. Has the option to iterate in the reverse order.
 *
 * @param block The block to be applied to each cell position.
 * @param reverse If YES, iterate in the reverse order.
 */
- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse;


/**
 * Returns the cell at the specified position.
 *
 * @param position The position we are interested in.
 * @return The cell at the position. If position out of bound, returns nil.
 */
- (M2Cell *)cellAtPosition:(M2Position)position;


/**
 * Returns the tile at the specified position.
 *
 * @param position The position we are interested in.
 * @return The tile at the position. If position out of bound or cell empty, returns nil.
 */
- (M2Tile *)tileAtPosition:(M2Position)position;


/**
 * Whether there are any available cells in the grid.
 *
 * @return YES if there are at least one cell available.
 */
- (BOOL)hasAvailableCells;

/**
 * Returns all available cells in an array.
 * @return The array of all available cells. If no cell is available, returns empty array.
 */
- (NSArray *)availableCells;

/**
 * Inserts a new tile at a randomly chosen position that's available.
 *
 * @param delay If YES, adds twice `animationDuration` long delay before the insertion.
 */
- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay;

/**
 *  Insert a tile at a given position.
 *  @param position A given position.
 *  @param level The level of this tile.
 *  @note This method is for grid copying and debugging only. Do not use in the regular logic.
 */
- (void)insertTileAtPosition:(M2Position)position withLevel:(NSUInteger)level;

/**
 *  Remove the tile at given position.
 *  @param position A given position.
 *  @note This method is for AI only. Do not use in the regular logic.
 */
- (void)removeTileAtPosition:(M2Position)position;

/**
 * Removes all tiles in the grid from the scene.
 *
 * @param animated If YES, animate the removal.
 */
- (void)removeAllTilesAnimated:(BOOL)animated;

@end
