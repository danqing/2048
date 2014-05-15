//
//  M2AITests.m
//  m2048
//
//  Created by Sihao Lu on 4/22/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Kiwi.h>
#import "M2DisplayTile.h"
#import "M2Grid.h"
#import "M2Grid+AI.h"
#import "M2Vector.h"

SPEC_BEGIN(AI_SPEC)

__block M2Grid *grid, *grid2, *grid3, *grid4, *grid42, *grid5, *grid6, *grid6MergeLeft, *grid7, *complexGrid, *complexGrid2, *complexGridMergedDown, *complexGridMergedRight, *winning, *gameover, *gameover2, *downProblem;

__block NSArray *notWinning, *gameNotOver;

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
    
    rawGrid = @[@[@1, @4, @7, @5],
                @[@4, @3, @5, @2],
                @[@1, @3, @11, @1],
                @[@1, @2, @4, @2]];
    winning = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @4, @7, @5],
                @[@4, @2, @5, @2],
                @[@1, @3, @4, @1],
                @[@2, @1, @3, @2]];
    gameover = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @2, @1, @2],
                @[@2, @1, @2, @1],
                @[@1, @2, @1, @2],
                @[@2, @1, @2, @1]];
    gameover2 = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    rawGrid = @[@[@1, @2, @1, @2],
                @[@2, @1, @2, @1],
                @[@1, @2, @1, @2],
                @[@2, @1, @2, @1]];
    downProblem = [[M2Grid alloc] initWithRawGrid:rawGrid];
    
    notWinning = @[grid, grid2, grid3, grid4, grid5, grid6, grid7, complexGrid, gameover, gameover2];
    gameNotOver = @[grid, grid2, grid3, grid4, grid5, grid6, grid7, complexGrid, winning];
});

describe(@"Debugging methods in grid", ^{
    it(@"should initialize grid correctly", ^{
        [[theValue([grid tileAtPosition:M2PositionMake(0, 1)].level) should] equal:theValue(1)];
        [[theValue([grid tileAtPosition:M2PositionMake(0, 3)].level) should] equal:theValue(2)];
    });
    
    it(@"should build an array exactly as the original one", ^{
        M2Grid *gridX = [[M2Grid alloc] initWithDimension:4];
        [gridX insertDummyTileAtPosition:M2PositionMake(0, 0) withLevel:2];
        [gridX insertDummyTileAtPosition:M2PositionMake(0, 1) withLevel:1];
        [gridX insertDummyTileAtPosition:M2PositionMake(1, 0) withLevel:3];
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
            id <M2Tile> tile = [complexGrid tileAtPosition:position];
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
        [[[grid3 copy] should] equal:grid3];
    });
    
    describe(@"cell comparison", ^{
        it(@"should work", ^{
            [[[grid6 cellAtPosition:M2PositionMake(1, 2)] should] equal:[grid7 cellAtPosition:M2PositionMake(1, 2)]];
            [[[grid6 cellAtPosition:M2PositionMake(3, 3)] should] equal:[grid7 cellAtPosition:M2PositionMake(3, 3)]];
            [[[grid6 cellAtPosition:M2PositionMake(3, 0)] shouldNot] equal:[grid7 cellAtPosition:M2PositionMake(3, 3)]];
        });
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
            M2Grid *merged = [complexGrid gridAfterMoveInDirection:M2VectorDown];
            [[merged should] equal:complexGridMergedDown];
            M2Grid *g6Merged = [grid6 gridAfterMoveInDirection:M2VectorLeft];
            [[g6Merged should] equal:grid6MergeLeft];
            M2Grid *complexMergedRight = [complexGrid gridAfterMoveInDirection:M2VectorRight];
            [[complexMergedRight should] equal:complexGridMergedRight];
            [[complexGridMergedDown shouldNot] equal:complexGrid];
            [[[complexGrid gridAfterMoveInDirection:M2VectorUp] shouldNot] equal:complexGrid];
            [[[complexGrid gridAfterMoveInDirection:M2VectorLeft] should] equal:complexGrid];
            
            M2Grid *xgrid = [[M2Grid alloc] initWithRawGrid:@[@[@1, @1, @0, @0],
                                                             @[@0, @0, @3, @0],
                                                             @[@0, @0, @0, @2],
                                                             @[@2, @0, @0, @0]]];
            M2Grid *xgridLeft = [[M2Grid alloc] initWithRawGrid:@[@[@2, @0, @0, @0],
                                                                  @[@3, @0, @0, @0],
                                                                  @[@2, @0, @0, @0],
                                                                  @[@2, @0, @0, @0]]];
            M2Grid *xgridDown = [[M2Grid alloc] initWithRawGrid:@[@[@0, @0, @0, @0],
                                                                  @[@0, @0, @0, @0],
                                                                  @[@1, @0, @0, @0],
                                                                  @[@2, @1, @3, @2]]];
            M2Grid *xgridUp = [[M2Grid alloc] initWithRawGrid:@[@[@1, @1, @3, @2],
                                                                @[@2, @0, @0, @0],
                                                                @[@0, @0, @0, @0],
                                                                @[@0, @0, @0, @0]]];
            M2Grid *xgridRight = [[M2Grid alloc] initWithRawGrid:@[@[@0, @0, @0, @2],
                                                                   @[@0, @0, @0, @3],
                                                                   @[@0, @0, @0, @2],
                                                                   @[@0, @0, @0, @2]]];
            [[[xgrid gridAfterMoveInDirection:M2VectorLeft] should] equal:xgridLeft];
            [[[xgrid gridAfterMoveInDirection:M2VectorDown] should] equal:xgridDown];
            [[[xgrid gridAfterMoveInDirection:M2VectorUp] should] equal:xgridUp];
            [[[xgrid gridAfterMoveInDirection:M2VectorRight] should] equal:xgridRight];
            
            M2Grid *cannotMoveDown = [[M2Grid alloc] initWithRawGrid:@[@[@0, @0, @5, @2],
                                                                       @[@0, @3, @2, @3],
                                                                       @[@0, @8, @6, @2],
                                                                       @[@1, @2, @1, @3]]];
            
            M2Grid *cannotMoveDownMoveLeft = [[M2Grid alloc] initWithRawGrid:@[@[@5, @2, @0, @0],
                                                                               @[@3, @2, @3, @0],
                                                                               @[@8, @6, @2, @0],
                                                                               @[@1, @2, @1, @3]]];
            [[[cannotMoveDown gridAfterMoveInDirection:M2VectorLeft] should] equal:cannotMoveDownMoveLeft];
            [[[cannotMoveDown gridAfterMoveInDirection:M2VectorDown] should] equal:cannotMoveDown];

            [[[downProblem gridAfterMoveInDirection:M2VectorDown] should] equal:downProblem];
            
        });
    });
    
    describe(@"check if merge-able", ^{
       it(@"should be correct", ^{
           for (M2Vector *vector in M2Vectors) {
               [[theValue([gameover isMovableInDirection:vector]) should] beNo];
               [[theValue([gameover2 isMovableInDirection:vector]) should] beNo];
               [[theValue([grid2 isMovableInDirection:vector]) should] beYes];
               [[theValue([grid5 isMovableInDirection:vector]) should] beYes];
           }
           [[theValue([grid isMovableInDirection:M2VectorUp]) should] beNo];
           [[theValue([grid isMovableInDirection:M2VectorRight]) should] beYes];
           [[theValue([grid isMovableInDirection:M2VectorDown]) should] beYes];

           [[theValue([complexGrid isMovableInDirection:M2VectorLeft]) should] beNo];
           [[theValue([complexGrid isMovableInDirection:M2VectorDown]) should] beYes];

       });
    });
    
    describe(@"winning board check", ^{
       it(@"should be correct", ^{
           for (M2Grid *theGrid in notWinning) {
               [[theValue([theGrid isWinningBoard]) should] beNo];
           }
           [[theValue([winning isWinningBoard]) should] beYes];
       });
    });
    
    describe(@"game over check", ^{
        it(@"should be correct", ^{
            for (M2Grid *theGrid in gameNotOver) {
                [[theValue([theGrid isGameOver]) should] beNo];
            }
            [[theValue([gameover isGameOver]) should] beYes];
            [[theValue([gameover2 isGameOver]) should] beYes];
        });
    });
});

SPEC_END
