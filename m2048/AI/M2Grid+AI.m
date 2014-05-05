//
//  M2Grid+AI.m
//  m2048
//
//  Created by Sihao Lu on 4/19/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Grid+AI.h"
#import "M2Tile.h"
#import "M2Vector.h"

@implementation M2Grid (AI)

- (double)heuristicValue {
    NSInteger emptyCellCount = self.availableCells.count;
    double smoothWeight = 0.1, monoWeight = 1.0, emptyWeight = 2.7, maxWeight = 1.0;
    
    return self.smoothness * smoothWeight
    + self.monotonicity * monoWeight
    + log(emptyCellCount) * emptyWeight
    + self.maxLevel * maxWeight;
}

- (NSInteger)maxLevel {
    __block NSInteger maxValue = 2;
    [self forEach:^(M2Position position) {
        M2Tile *tile = [self tileAtPosition:position];
        if (tile.level > maxValue) maxValue = tile.level;
    } reverseOrder:NO];
    return maxValue;
}

- (NSInteger)smoothness {
    __block NSInteger smoothness = 0;
    [self forEach:^(M2Position position) {
        M2Cell *cell = [self cellAtPosition:position];
        M2Tile *rightTile = [[self nextCellFromCell:cell inDirection:M2VectorRight] tile];
        M2Tile *downTile = [[self nextCellFromCell:cell inDirection:M2VectorDown] tile];
        if (cell.tile && rightTile) smoothness -= ABS(cell.tile.level - rightTile.level);
        if (cell.tile && downTile) smoothness -= ABS(cell.tile.level - downTile.level);
    } reverseOrder:NO];
    return smoothness;
}

- (double)monotonicity {
    __block NSInteger up = 0, down = 0, left = 0, right = 0;
    [self forEach:^(M2Position position) {
        M2Cell *cell = [self cellAtPosition:position];
        NSInteger difference;

        M2Cell *rightCell = [self nextCellFromCell:cell inDirection:M2VectorRight];
        if (rightCell) {
            M2Tile *rightTile = [rightCell tile];
            if (!rightTile) difference = cell.tile.level;
            difference = cell.tile.level - rightTile.level;
            if (difference > 0) right -= difference;
        }

        M2Cell *leftCell = [self nextCellFromCell:cell inDirection:M2VectorLeft];
        if (leftCell) {
            M2Tile *leftTile = leftCell.tile;
            if (!leftTile) difference = cell.tile.level;
            difference = cell.tile.level - leftTile.level;
            if (difference > 0) left -= difference;
        }
        
        M2Cell *downCell = [self nextCellFromCell:cell inDirection:M2VectorDown];
        if (downCell) {
            M2Tile *downTile = [downCell tile];
            if (!downTile) difference = cell.tile.level;
            difference = cell.tile.level - downTile.level;
            if (difference > 0) down -= difference;
        }
        
        M2Cell *upCell = [self nextCellFromCell:cell inDirection:M2VectorUp];
        if (upCell) {
            M2Tile *upTile = [upCell tile];
            if (!upTile) difference = cell.tile.level;
            difference = cell.tile.level - upTile.level;
            if (difference > 0) up -= difference;
        }
    } reverseOrder:NO];
    
    return MAX(up, down) + MAX(left, right);
}

- (M2Grid *)gridAfterMoveWithDirection:(M2Vector *)direction {
    M2Grid *grid = [self copy];
    
    __block NSMutableArray *merged = [NSMutableArray arrayWithArray:@[@NO, @NO, @NO, @NO]];
    [self forEach:^(M2Position position) {
        M2Cell *cell = [grid cellAtPosition:position];
        if (cell.tile) {
            NSInteger mergedIndex = direction.y == 0 ? position.y : position.x;
            M2Cell *nextCell = [grid nextCellFromCell:cell inDirection:direction];
            if (nextCell.tile) {
                if (nextCell.tile.level != cell.tile.level || (nextCell.tile.level == cell.tile.level && [merged[mergedIndex] boolValue])) {
                    // If unable to merge, move only
                    M2Cell *targetCell = [grid farthestEmptyCellFromCell:cell inDirection:direction];
                    if (targetCell.position.x != cell.position.x || targetCell.position.y != targetCell.position.y) {
                        targetCell.tile = cell.tile;
                        cell.tile = nil;
                    }
                } else {
                    // Able to merge
                    nextCell.tile.level++;
                    cell.tile = nil;
                    merged[mergedIndex] = @YES;
                }
            }
        }
    } reverseOrder:direction.y == 1 || direction.x == 1];
    
    return grid;
}

- (BOOL)isWinningBoard {
    __block BOOL winning = NO;
    [self forEach:^(M2Position position) {
        M2Cell *cell = [self cellAtPosition:position];
        if (cell.tile && cell.tile.level == GSTATE.winningLevel) {
            winning = YES;
            return;
        }
    } reverseOrder:NO];
    return winning;
}

- (BOOL)isGameOver {
    if ([self hasAvailableCells]) return NO;
    __block BOOL cannotMerge = YES;
    [self forEach:^(M2Position position) {
        M2Cell *cell = [self cellAtPosition:position];
        if (cell.tile) {
            M2Tile *rightTile = [[self nextCellFromCell:cell inDirection:M2VectorRight] tile];
            M2Tile *downTile = [[self nextCellFromCell:cell inDirection:M2VectorDown] tile];
            if (cell.tile.level == rightTile.level || cell.tile.level == downTile.level) {
                cannotMerge = NO;
                return;
            }
        }
    } reverseOrder:NO];
    return cannotMerge;
}

#pragma mark - Helpers

/**
 *  Return the next cell in a direction represented by vector. If no other cells are in that direction of the cell,
 *  the adjacent cell in the direction will be returned.
 *  @param cell The current cell.
 *  @param direction The direction represented by a vector.
 *  @return The next cell.
 */
- (M2Cell *)nextCellFromCell:(M2Cell *)cell inDirection:(M2Vector *)direction {
    M2Position position = cell.position;
    do {
        position.x += direction.x;
        position.y += direction.y;
    } while ([self cellAtPosition:position] && ![self tileAtPosition:position]);
    M2Position nextAdjacentPosition = M2PositionMake(cell.position.x + direction.x, cell.position.y + direction.y);
    if (![self cellAtPosition:position]) return [self cellAtPosition:nextAdjacentPosition];
    return [self cellAtPosition:position];
}

- (M2Cell *)farthestEmptyCellFromCell:(M2Cell *)cell inDirection:(M2Vector *)direction {
    M2Position position = cell.position;
    do {
        position.x += direction.x;
        position.y += direction.y;
    } while ([self cellAtPosition:position] && ![self tileAtPosition:position]);
    M2Position farthestPosition = M2PositionMake(position.x - direction.x, position.y - direction.y);
    return [self cellAtPosition:farthestPosition];
}

#pragma mark - Debugging

- (void)dumpGrid {
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"Grid:\n"];
    for (NSInteger i = 0; i < self.dimension; i++) {
        for (NSInteger j = 0; j < self.dimension; j++) {
            M2Tile *tile = [self tileAtPosition:M2PositionMake(i, j)];
            [result appendFormat:@"%ld ", (long)(tile ? tile.level : 0)];
        }
        [result appendFormat:@"\n"];
    }
    NSLog(@"%@", result);
}

@end
