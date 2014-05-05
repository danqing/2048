//
//  M2AITests.m
//  m2048
//
//  Created by Sihao Lu on 4/22/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Kiwi.h>
#import "M2Tile.h"
#import "M2Grid.h"
#import "M2Grid+AI.h"
#import "M2Vector.h"

SPEC_BEGIN(AI_SPEC)

__block M2Grid *grid, *grid2, *grid3, *grid4, *grid42, *grid5, *grid6, *grid6MergeLeft, *grid7, *complexGrid, *complexGrid2, *complexGridMergedDown, *complexGridMergedRight;

beforeAll(^{
    NSArray *rawGrid = @[@[@0, @1, @1, @2],
                         @[@0, @0, @0, @0],
                         @[@0, @0, @0, @0],
                         @[@0, @0, @0, @0]];
    grid = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@0, @1, @1, @2],
                @[@3, @1, @0, @0],
                @[@0, @2, @0, @0],
                @[@0, @0, @0, @0]];
    grid2 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@0, @2, @1, @2],
                @[@2, @1, @0, @0],
                @[@0, @4, @0, @0],
                @[@1, @2, @0, @1]];
    grid3 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@2, @1, @0, @0],
                @[@3, @0, @0, @0],
                @[@0, @0, @0, @0],
                @[@0, @0, @0, @0]];
    grid4 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    grid42 = [[M2Grid alloc] initWithRawGrid:rawGrid];

    rawGrid = @[@[@1, @1, @2, @1],
                @[@0, @6, @0, @4],
                @[@0, @0, @0, @2],
                @[@0, @0, @1, @0]];
    grid5 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @6, @2, @0],
                @[@2, @3, @4, @2],
                @[@4, @1, @2, @0],
                @[@1, @0, @0, @1]];
    grid6 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @6, @2, @0],
                @[@2, @3, @4, @2],
                @[@4, @1, @2, @0],
                @[@2, @0, @0, @0]];
    grid6MergeLeft = [[M2Grid alloc] initWithRawGrid:rawGrid];

    rawGrid = @[@[@0, @0, @0, @0],
                @[@3, @0, @0, @0],
                @[@7, @2, @0, @1],
                @[@4, @3, @2, @1]];
    grid7 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @4, @7, @5],
                @[@4, @3, @5, @2],
                @[@1, @3, @4, @1],
                @[@1, @2, @4, @2]];
    complexGrid = [[M2Grid alloc] initWithRawGrid:rawGrid];
    complexGrid2 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@0, @0, @0, @5],
                @[@1, @4, @7, @2],
                @[@4, @4, @5, @1],
                @[@2, @2, @5, @2]];
    complexGridMergedDown = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @4, @7, @5],
                @[@4, @3, @5, @2],
                @[@1, @3, @4, @1],
                @[@1, @2, @4, @2]];
    complexGridMergedRight = [[M2Grid alloc] initWithRawGrid:rawGrid];
});

describe(@"Debugging methods in grid", ^{
    it(@"should initialize grid correctly", ^{
        [[theValue([grid tileAtPosition:M2PositionMake(0, 1)].level) should] equal:theValue(1)];
        [[theValue([grid tileAtPosition:M2PositionMake(0, 3)].level) should] equal:theValue(2)];
    });
    
    it(@"should build an array exactly as the original one", ^{
        M2Grid *gridX = [[M2Grid alloc] initWithDimension:4];
        [gridX insertTileAtPosition:M2PositionMake(0, 0) withLevel:2];
        [gridX insertTileAtPosition:M2PositionMake(0, 1) withLevel:1];
        [gridX insertTileAtPosition:M2PositionMake(1, 0) withLevel:3];
        [[theValue(gridX.smoothness) should] equal:theValue(-2)];
        [[theValue(gridX.monotonicity) should] equal:theValue(-1)];
        [[gridX should] equal:grid4];
    });
    
    it(@"should correctly remove tile", ^{
        NSArray *rawGrid = @[@[@0, @0, @0, @5],
                             @[@1, @4, @7, @2],
                             @[@4, @4, @0, @1],
                             @[@0, @2, @5, @2]];
        M2Grid *mergeDownCopy = [complexGridMergedDown copy];
        [mergeDownCopy removeTileAtPosition:M2PositionMake(2, 2)];
        [mergeDownCopy removeTileAtPosition:M2PositionMake(3, 0)];
        M2Grid *resultGrid = [[M2Grid alloc] initWithRawGrid:rawGrid];
        [[mergeDownCopy should] equal:resultGrid];
    });
});

describe(@"Grid copying", ^{
    it(@"should work", ^{
        M2Grid *newGird = [complexGrid copy];
        [complexGrid forEach:^(M2Position position) {
            M2Tile *tile = [complexGrid tileAtPosition:position];
            [[theValue(tile.level) should] equal:theValue([[newGird tileAtPosition:position] level])];
        } reverseOrder:NO];
    });
});

describe(@"Grid comparison", ^{
   it(@"should work", ^{
       [[[complexGrid copy] should] equal:complexGrid];
       [[[complexGrid copy] should] equal:complexGrid2];
       [[[grid4 copy] shouldNot] equal:grid3];
       [[[grid4 copy] should] equal:grid42];
       [[[grid5 copy] should] equal:grid5];
       
       NSLog(@"%lu %lu", (unsigned long)complexGrid.hash, (unsigned long)complexGrid2.hash);
       [complexGrid2 dumpGrid];
       [complexGrid dumpGrid];
       [[[grid3 copy] should] equal:grid3];
   });
});

describe(@"In grid extension", ^{
    describe(@"smoothness", ^{
        it(@"should be correct", ^{
            [[theValue(grid4.smoothness) should] equal:theValue(-2)];
            [[theValue(grid5.smoothness) should] equal:theValue(-15)];
            [[theValue(grid6.smoothness) should] equal:theValue(-33)];
            [[theValue(grid7.smoothness) should] equal:theValue(-17)];
            [[theValue(complexGrid.smoothness) should] equal:theValue(-41)];
        });
    });
    describe(@"maximum", ^{
        it(@"should be correct", ^{
            [[theValue(grid.maxLevel) should] equal:theValue(2)];
            [[theValue(grid2.maxLevel) should] equal:theValue(3)];
            [[theValue(grid3.maxLevel) should] equal:theValue(4)];
            [[theValue(complexGrid.maxLevel) should] equal:theValue(7)];
        });
    });
    describe(@"monotonicity", ^{
        it(@"should be correct", ^{
            [[theValue(grid4.monotonicity) should] equal:theValue(-1)];
            [[theValue(grid5.monotonicity) should] equal:theValue(-12)];
            [[theValue(grid6.monotonicity) should] equal:theValue(-15)];
            [[theValue(grid7.monotonicity) should] equal:theValue(-3)];
            [[theValue(complexGrid.monotonicity) should] equal:theValue(-15)];
        });
    });
    describe(@"heuristic value", ^{
       it(@"should be close enough", ^{
           M2Grid *grid = [[M2Grid alloc] initWithRawGrid:@[@[@0, @0, @0, @1],
                                                            @[@0, @0, @0, @0],
                                                            @[@0, @0, @0, @0],
                                                            @[@2, @0, @0, @0]]];
           [[theValue(grid.heuristicValue) should] equal:7.125 withDelta:0.001];
       });
    });
    describe(@"merge", ^{
        it(@"shoule be correct stepwisely", ^{
            M2Grid *merged = [complexGrid gridAfterMoveWithDirection:M2VectorDown];
            [[merged should] equal:complexGridMergedDown];
            M2Grid *g6Merged = [grid6 gridAfterMoveWithDirection:M2VectorLeft];
            [[g6Merged should] equal:grid6MergeLeft];
            M2Grid *complexMergedRight = [complexGrid gridAfterMoveWithDirection:M2VectorRight];
            [[complexMergedRight should] equal:complexGridMergedRight];
        });
    });
});

SPEC_END
