//
//  M2Grid.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//
#include "stdlib.h"

#import "M2Grid.h"
#import "M2DisplayTile.h"
#import "M2DummyTile.h"
#import "M2Scene.h"

@interface M2Grid ()

@property (nonatomic, readwrite) NSInteger dimension;

@end


@implementation M2Grid {
  /* The 2-D grid that keeps track of all cells and tiles. */
  NSMutableArray *_grid;
}

- (instancetype)initWithDimension:(NSInteger)dimension
{
  if (self = [super init]) {
    // Set up the grid with all empty cells.
    _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
    
    for (NSInteger i = 0; i < dimension; i++) {
      NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
      for (NSInteger j = 0; j < dimension; j++) {
        [array addObject:[[M2Cell alloc] initWithPosition:M2PositionMake(i, j)]];
      }
      [_grid addObject:array];
    }
    
    // Record the dimension of the grid.
    self.dimension = dimension;
    
    // Draw the board.å
  }
  
  return self;
}

# pragma mark - Iterator

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse
{
  if (!reverse) {
    for (NSInteger i = 0; i < self.dimension; i++) {
      for (NSInteger j = 0; j < self.dimension; j++) {
        block(M2PositionMake(i, j));
      }
    }
  } else {
    for (NSInteger i = self.dimension - 1; i >= 0; i--) {
      for (NSInteger j = self.dimension - 1; j >= 0; j--) {
        block(M2PositionMake(i, j));
      }
    }
  }
}


# pragma mark - Position helpers

- (M2Cell *)cellAtPosition:(M2Position)position
{
  if (position.x >= self.dimension || position.y >= self.dimension ||
      position.x < 0 || position.y < 0) return nil;
  return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}


- (id <M2Tile>)tileAtPosition:(M2Position)position
{
  M2Cell *cell = [self cellAtPosition:position];
  return cell ? cell.tile : nil;
}


# pragma mark - Cell availability

- (BOOL)hasAvailableCells
{
  return [self availableCells].count != 0;
}


/**
 * Returns a randomly chosen cell that's available.
 *
 * @return A randomly chosen available cell, or nil if no cell is available.
 */
- (M2Cell *)randomAvailableCell
{
  NSArray *availableCells = [self availableCells];
  if (availableCells.count) {
    return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
  }
  return nil;
}


- (NSArray *)availableCells
{
  NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
  [self forEach:^(M2Position position) {
    M2Cell *cell = [self cellAtPosition:position];
    if (!cell.tile) [array addObject:cell];
  } reverseOrder:NO];
  return array;
}


# pragma mark - Cell manipulation

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay
{
  M2Cell *cell = [self randomAvailableCell];
  if (cell) {
    M2DisplayTile *tile = [M2DisplayTile insertNewTileToCell:cell];
    [self.scene addChild:tile];
    
    SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] :
                                    [SKAction waitForDuration:0];
    SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.tileSize / 2, - GSTATE.tileSize / 2)
                             duration:GSTATE.animationDuration];
    SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
    [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move, scale]]]]];
  }
}

- (void)insertDummyTileAtPosition:(M2Position)position withLevel:(NSUInteger)level {
    M2Cell *cell = [self cellAtPosition:position];
    if (cell && cell.tile && [[self.scene children] indexOfObject:cell.tile] != NSNotFound) {
        [NSException raise:@"Error replacing existing cell on board." format:@"Existing cell at position (%ld, %ld) cannot be replaced. Please do not use this method in regular logic.", (long)position.x, (long)position.y];
    }
    [M2DummyTile insertNewTileToCell:cell];
    cell.tile.level = level;
}

- (void)removeTileAtPosition:(M2Position)position {
    M2Cell *cell = [self cellAtPosition:position];
    if (cell && cell.tile) {
        cell.tile = nil;
    } else {
        [NSException raise:@"Cannot remove tile." format:@"Cannot remove tile at position (%ld, %ld). Position not valid or tile not exist.", (long)position.x, (long)position.y];
    }
}

- (void)removeAllTilesAnimated:(BOOL)animated
{
  [self forEach:^(M2Position position) {
    id <M2Tile> tile = [self tileAtPosition:position];
    if (tile && [tile isKindOfClass:[M2DisplayTile class]]) [(M2DisplayTile *)tile removeAnimated:animated];
  } reverseOrder:NO];
}

#pragma mark - NSCopying

// The -copy method will make dummy cells
- (id)copyWithZone:(NSZone *)zone {
    M2Grid *newGrid = [[M2Grid alloc] initWithDimension:self.dimension];
    [self forEach:^(M2Position position) {
        id <M2Tile> tile = [self tileAtPosition:position];
        if (tile) {
            [newGrid insertDummyTileAtPosition:position withLevel:tile.level];
        }
    } reverseOrder:NO];
    return newGrid;
}

#pragma mark - Comparison
- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return [self isEqualToGrid:object];
}

- (BOOL)isEqualToGrid:(M2Grid *)grid {
    if (grid == self) return YES;
    if (!grid) return NO;
    __block BOOL allTilesEqual = YES;
    [self forEach:^(M2Position position) {
        id <M2Tile> tile = [self tileAtPosition:position];
        id <M2Tile> otherTile = [grid tileAtPosition:position];
        if (tile && (!otherTile || tile.level != otherTile.level)) {
            allTilesEqual = NO;
        }
    } reverseOrder:NO];
    return allTilesEqual;
}

- (NSUInteger)hash {
    __block NSUInteger prime = 31, prime2 = 17, prime3 = 13, prime4 = 7;
    __block NSUInteger result = 1;
    [self forEach:^(M2Position position) {
        id <M2Tile> tile = [self tileAtPosition:position];
        result = prime * result + prime2 * position.x + prime3 * position.y + prime4 * tile.level;
    } reverseOrder:NO];
    return result;
}

@end
