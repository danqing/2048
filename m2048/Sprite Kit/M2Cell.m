//
//  M2Cell.m
//  m2048
//
//  Created by Danqing on 3/17/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Cell.h"
#import "M2DisplayTile.h"

@implementation M2Cell

- (instancetype)initWithPosition:(M2Position)position
{
  if (self = [super init]) {
    self.position = position;
    self.tile = nil;
  }
  return self;
}


- (void)setTile:(M2DisplayTile *)tile
{
  _tile = tile;
  if (tile) tile.cell = self;
}

#pragma mark - Equality
- (NSUInteger)hash {
    return 31 * self.position.x + self.position.y;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    M2Cell *cell = object;
    return self.position.x == cell.position.x && self.position.y == cell.position.y;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    M2Cell *cell = [[M2Cell alloc] initWithPosition:self.position];
    return cell;
}

@end
