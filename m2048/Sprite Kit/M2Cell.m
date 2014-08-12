//
//  M2Cell.m
//  m2048
//
//  Created by Danqing on 3/17/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Cell.h"
#import "M2Tile.h"
static int blockCount = 0;
@implementation M2Cell
- (instancetype)initWithPosition:(M2Position)position
{
  if (self = [super init]) {
    self.position = position;
    self.tile = nil;
      self.blockId = blockCount++;
  }
  return self;
}

- (NSString*)description{
    return [self debugDescription];
}
- (NSString*)debugDescription{
    return [NSString stringWithFormat:@"%d(%d,%d)", self.level, self.position.x, self.position.y];
}
- (instancetype)initWithM2Cell:(M2Cell*)cell{
    if (self = [super init]) {
        self.position = cell.position;
        _tile = cell.tile;
        self.level = _tile.level;
        self.blockId = cell.blockId;
    }
    return self;
}

- (void)setTile:(M2Tile *)tile
{
  _tile = tile;
  if (tile) tile.cell = self;
}

@end
