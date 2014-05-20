//
//  M2DummyTile.m
//  m2048
//
//  Created by Sihao Lu on 5/11/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2DummyTile.h"
#import "M2Cell.h"

@implementation M2DummyTile

@synthesize level = _level;
@synthesize cell = _cell;

+ (instancetype)insertNewTileToCell:(M2Cell *)cell
{
    M2DummyTile *tile = [[M2DummyTile alloc] init];
    cell.tile = tile;
    return tile;
}

- (BOOL)canMergeWithTile:(id <M2Tile>)tile {
    if (!tile || ![tile isKindOfClass:[M2DummyTile class]]) return NO;
    return [GSTATE isLevel:self.level mergeableWithLevel:tile.level];
}

- (void)moveToCell:(M2Cell *)cell {
    self.cell.tile = nil;
    cell.tile = self;
}

// Not implemented, because the AI has its own way to merge cells.
- (NSInteger)mergeToTile:(id <M2Tile>)tile {
    if (![tile isKindOfClass:[M2DummyTile class]]) return 0;
    return 0;
}

// Not implemented
- (NSInteger)merge3ToTile:(id <M2Tile>)tile andTile:(id <M2Tile>)furtherTile {
    if (![tile isKindOfClass:[M2DummyTile class]] || ![furtherTile isKindOfClass:[M2DummyTile class]]) return 0;
    return 0;
}

@end
