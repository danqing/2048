//
//  M2Tile.h
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

@import SpriteKit;
@class M2Cell;

@interface M2Tile : SKShapeNode

/** The level of the tile. */
@property (nonatomic) NSInteger level;

/** The cell this tile belongs to. */
@property (nonatomic, weak) M2Cell *cell;

/**
 * Creates and inserts a new tile at the specified cell.
 *
 * @param cell The cell to insert tile into.
 * @return The tile created.
 */
+ (M2Tile *)insertNewTileToCell:(M2Cell *)cell;

- (void)commitPendingActions;

/**
 * Whether this tile can merge with the given tile.
 *
 * @param tile The target tile to merge with.
 * @return YES if the two tiles can be merged.
 */
- (BOOL)canMergeWithTile:(M2Tile *)tile;


/**
 * Checks whether this tile can merge with the given tile, and merge them
 * if possible. The resulting tile is at the position of the given tile.
 *
 * @param tile Target tile to merge into.
 * @return The resulting level of the merge, or 0 if unmergeable.
 */
- (NSInteger)mergeToTile:(M2Tile *)tile;

- (NSInteger)merge3ToTile:(M2Tile *)tile andTile:(M2Tile *)furtherTile;

/**
 * Moves the tile to the specified cell. If the tile is not already in the grid, 
 * calling this method would result in error.
 *
 * @param cell The destination cell.
 */
- (void)moveToCell:(M2Cell *)cell;


/**
 * Removes the tile from its cell and from the scene.
 *
 * @param animated If YES, the removal will be animated.
 */
- (void)removeAnimated:(BOOL)animated;

@end
