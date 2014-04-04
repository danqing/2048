//
//  M2Tile.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#include <stdlib.h>

#import "M2Tile.h"
#import "M2Cell.h"

@implementation M2Tile {
  /** The value of the tile, as some text. */
  SKLabelNode *_value;
  
  /** Pending actions for the tile to execute. */
  NSMutableArray *_pendingActions;
}


# pragma mark - Tile creation

+ (M2Tile *)insertNewTileToCell:(M2Cell *)cell
{
  M2Tile *tile = [[M2Tile alloc] init];
  
  // The initial position of the tile is at the center of its cell. This is so because when
  // scaling the tile, SpriteKit does so from the origin, not the center. So we have to scale
  // the tile while moving it back to its normal position to achieve the "pop out" effect.
  CGPoint origin = [GSTATE locationOfPosition:cell.position];
  tile.position = CGPointMake(origin.x + GSTATE.tileSize / 2, origin.y + GSTATE.tileSize / 2);
  [tile setScale:0];
  
  cell.tile = tile;
  return tile;
}


- (instancetype)init
{
  if (self = [super init]) {
    // Layout of the tile.
    CGRect rect = CGRectMake(0, 0, GSTATE.tileSize, GSTATE.tileSize);
    CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, NULL);
    self.path = rectPath;
    CFRelease(rectPath);
    self.lineWidth = 0;
    
    // Initiate pending actions queue.
    _pendingActions = [[NSMutableArray alloc] init];
    
    // Set up value label.
    _value = [SKLabelNode labelNodeWithFontNamed:[GSTATE boldFontName]];
    _value.position = CGPointMake(GSTATE.tileSize / 2, GSTATE.tileSize / 2);
    _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:_value];
    
    // For Fibonacci game, which is way harder than 2048 IMO, 40 seems to be the easiest number.
    // 90 definitely won't work, as we need approximately equal number of 2 and 3 to make the
    // game remotely makes sense.
    if (GSTATE.gameType == M2GameTypeFibonacci) self.level = arc4random_uniform(100) < 40 ? 1 : 2;
    else self.level = arc4random_uniform(100) < 95 ? 1 : 2;
    
    [self refreshValue];
  }
  return self;
}


# pragma mark - Public methods

- (void)removeFromParentCell
{
  // Check if the tile is still registered with its parent cell, and if so, remove it.
  // We don't really care about self.cell, because that is a weak pointer.
  if (self.cell.tile == self) self.cell.tile = nil;
}


- (BOOL)hasPendingMerge
{
  // A move is only one action, so if there are more than one actions, there must be
  // a merge that needs to be committed. If things become more complicated, change
  // this to an explicit ivar or property.
  return _pendingActions.count > 1;
}


- (void)commitPendingActions
{
  [self runAction:[SKAction sequence:_pendingActions]];
  [_pendingActions removeAllObjects];
}


- (BOOL)canMergeWithTile:(M2Tile *)tile
{
  if (!tile) return NO;
  return [GSTATE isLevel:self.level mergeableWithLevel:tile.level];
}


- (NSInteger)mergeToTile:(M2Tile *)tile
{
  // Cannot merge with thin air. Also cannot merge with tile that has a pending merge.
  // For the latter, imagine we have 4, 2, 2. If we move to the right, it will first
  // become 4, 4. Now we cannot merge the two 4's.
  if (!tile || [tile hasPendingMerge]) return 0;
  
  NSInteger newLevel = [GSTATE mergeLevel:self.level withLevel:tile.level];
  if (newLevel > 0) {
    // 1. Move self to the destination cell.
    [self moveToCell:tile.cell];
    
    // 2. Remove the tile in the destination cell.
    [tile removeWithDelay];
    
    // 3. Update value and pop.
    [self updateLevelTo:newLevel];
    [_pendingActions addObject:[self pop]];
  }
  return newLevel;
}


- (NSInteger)merge3ToTile:(M2Tile *)tile andTile:(M2Tile *)furtherTile
{
  if (!tile || [tile hasPendingMerge] || [furtherTile hasPendingMerge]) return 0;
  
  NSUInteger newLevel = MIN([GSTATE mergeLevel:self.level withLevel:tile.level],
                            [GSTATE mergeLevel:tile.level withLevel:furtherTile.level]);
  if (newLevel > 0) {
    // 1. Move self to the destination cell AND move the intermediate tile to there too.
    [tile moveToCell:furtherTile.cell];
    [self moveToCell:furtherTile.cell];
    
    // 2. Remove the tile in the destination cell.
    [tile removeWithDelay];
    [furtherTile removeWithDelay];
    
    // 3. Update value and pop.
    [self updateLevelTo:newLevel];
    [_pendingActions addObject:[self pop]];
  }
  return newLevel;
}


- (void)updateLevelTo:(NSInteger)level
{
  self.level = level;
  [_pendingActions addObject:[SKAction runBlock:^{
    [self refreshValue];
  }]];
}


- (void)refreshValue
{
  long value = [GSTATE valueForLevel:self.level];
  _value.text = [NSString stringWithFormat:@"%ld", value];
  _value.fontColor = [GSTATE textColorForLevel:self.level];
  _value.fontSize = [GSTATE textSizeForValue:value];
  
  self.fillColor = [GSTATE colorForLevel:self.level];
}


- (void)moveToCell:(M2Cell *)cell
{
  [_pendingActions addObject:[SKAction moveBy:[GSTATE distanceFromPosition:self.cell.position
                                                                toPosition:cell.position]
                                     duration:GSTATE.animationDuration]];
  self.cell.tile = nil;
  cell.tile = self;
}


- (void)removeAnimated:(BOOL)animated
{
  [self removeFromParentCell];
  // @TODO: fade from center.
  if (animated) [_pendingActions addObject:[SKAction scaleTo:0 duration:GSTATE.animationDuration]];
  [_pendingActions addObject:[SKAction removeFromParent]];
  [self commitPendingActions];
}


- (void)removeWithDelay
{
  [self removeFromParentCell];
  SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
  SKAction *remove = [SKAction removeFromParent];
  [self runAction:[SKAction sequence:@[wait, remove]]];
}


# pragma mark - SKAction helpers

- (SKAction *)pop
{
  CGFloat d = 0.15 * GSTATE.tileSize;
  SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration / 3];
  SKAction *enlarge = [SKAction scaleTo:1.3 duration:GSTATE.animationDuration / 1.5];
  SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:GSTATE.animationDuration / 1.5];
  SKAction *restore = [SKAction scaleTo:1 duration:GSTATE.animationDuration / 1.5];
  SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:GSTATE.animationDuration / 1.5];
  
  return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]],
                                    [SKAction group:@[restore, moveBack]]]];
}

@end
