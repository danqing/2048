//
//  M2Grid.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//
#include "stdlib.h"

#import "M2Grid.h"
#import "M2Tile.h"
#import "M2Scene.h"

@interface M2Grid ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, strong)  NSMutableArray *snapShots;
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
    
      self.snapShots = [@[] mutableCopy];
    // Record the dimension of the grid.
    self.dimension = dimension;
    
    // Draw the board.
  }
  
  return self;
}

-  (NSString*)description{
    return [self debugDescription];
}
-(NSString*)debugDescription{
    NSString *des = @"";
    
    for (NSInteger i = self.dimension - 1; i >= 0; i--) {
        for (NSInteger j = 0; j <  self.dimension; j++) {
            int level = [self tileAtPosition:M2PositionMake(i, j)].level;
            des = [des stringByAppendingFormat:@"%d,", level];
        }
        des = [des stringByAppendingString:@"\n"];
    }
    return des;
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


- (M2Tile *)tileAtPosition:(M2Position)position
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


/**
 * Returns all available cells in an array.
 *
 * @return The array of all available cells. If no cell is available, returns empty array.
 */
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
    M2Tile *tile = [M2Tile insertNewTileToCell:cell];
    [self.scene addChild:tile];
    
    SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] :
                                    [SKAction waitForDuration:0];
    SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.tileSize / 2, - GSTATE.tileSize / 2)
                             duration:GSTATE.animationDuration];
    SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
    [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move, scale]]]]];
  }
}


- (void)removeAllTilesAnimated:(BOOL)animated
{
  [self forEach:^(M2Position position) {
    M2Tile *tile = [self tileAtPosition:position];
    if (tile) [tile removeAnimated:animated];
  } reverseOrder:NO];
}

#pragma - mark udo
-(void)takeSnapshot{
    NSMutableArray *gridSnapshot = [[NSMutableArray alloc] initWithCapacity:self.dimension];
    
    for (NSInteger i = 0; i < self.dimension; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension];
        for (NSInteger j = 0; j < self.dimension; j++) {
            
            [array addObject:[[M2Cell alloc] initWithM2Cell:[self cellAtPosition:M2PositionMake(i, j)]]];
        }
        [gridSnapshot addObject:array];
    }
    // Check if it is the same as before one.
    if (self.snapShots.count > 0) {
        NSArray *array = self.snapShots.lastObject;
        BOOL identical = YES;
        for (int i = 0; i < self.dimension; i++) {
            for (int j = 0; j < self.dimension; j++) {
                M2Cell *prev = array[i][j];
                M2Cell *cur  = gridSnapshot[i][j];
                if (prev.level != cur.level) {
                    identical = NO;
                    [self.snapShots addObject:gridSnapshot];
                    NSLog(@"Taking snapshot\n%@",self);
                    break;
                }
            }
            if (!identical) {
                break;
            }
        }
        if (identical) {
            NSLog(@"Found duplicated snapshot\n%@", self);
        }
    }else{
        [self.snapShots addObject:gridSnapshot];
        NSLog(@"Taking snapshot\n%@",self);
    }
}
- (void)popSnapshot{
    if (self.snapShots.count > 0) {
        [self.snapShots removeLastObject];
    }
}
- (void)undo{
//    [self removeAllTilesAnimated:NO]
    if (self.snapShots.count > 0) {
        
        NSMutableArray *tiles = [@[] mutableCopy];
        [self forEach:^(M2Position position) {
            M2Tile *tile = [self tileAtPosition:position];
            if (tile) {
                tile.markedForRemove = YES;
                [tiles addObject:tile];
            }
        } reverseOrder:NO];
        
        _grid = [self.snapShots lastObject];
        [self.snapShots removeLastObject];
        
        // Animations
        [self forEach:^(M2Position position) {
            M2Tile *tile = [self tileAtPosition:position];
            M2Cell *cell = [self cellAtPosition:position];
            cell.tile = tile;
            if (tile) {
                // Check if the tile been removed in last operation.
                if (tile.parent == nil) {
                    [self.scene addChild:tile];
                }
                
                tile.level = [self cellAtPosition:position].level;
                CGPoint origin = [GSTATE locationOfPosition: position];
                SKAction *refresh = [SKAction runBlock:^{
                    [tile refreshValue];
                }];
                SKAction *move = [SKAction moveTo:CGPointMake(origin.x , origin.y)
                                         duration:GSTATE.animationDuration];
                SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
                [tile runAction:[SKAction sequence:@[[SKAction group:@[refresh, move, scale]]]]];
                tile.markedForRemove = NO;
            }
        } reverseOrder:NO];
        
        for (M2Tile *tile in tiles) {
            if (tile.markedForRemove) {
                [tile removeAnimated:YES];
            }
        }
    }
}
@end
