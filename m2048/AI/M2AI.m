//
//  M2AI.m
//  m2048
//
//  Created by Sihao Lu on 4/19/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AI.h"
#import "M2Grid.h"
#import "M2Grid+AI.h"

@interface M2AI ()

@property M2Grid *grid;

@property M2AIResult *bestResult;

@property NSTimer *timeOutTriggerTimer;

@end

@implementation M2AI

- (instancetype)initWithGrid:(M2Grid *)grid {
    self = [super init];
    if (self) {
        _grid = grid;
        _bestResult = nil;
    }
    return self;
}

- (M2AIResult *)searchWithPlayerTurn:(BOOL)playerTurn depth:(NSInteger)depth alpha:(double)alpha beta:(double)beta positions:(NSInteger)positions cutoffs:(NSInteger)cutoffs {

    double bestScore;
    M2Vector *bestMove;
    M2AIResult *result;
    if (playerTurn) {
        bestScore = alpha;
        for (M2Vector *direction in M2Vectors) {
            M2Grid *movedGrid = [self.grid gridAfterMoveWithDirection:direction];
            BOOL moved = ![movedGrid isEqual:self.grid];
            if (moved) {
                positions++;
                if ([movedGrid isWinningBoard]) {
                    return [[M2AIResult alloc] initWithMove:direction score:10000 positions:positions cutoffs:cutoffs];
                }
                if (depth == 0) {
                    result = [[M2AIResult alloc] initWithMove:direction score:movedGrid.heuristicValue positions:0 cutoffs:0];
                } else {
                    M2AI *newAI = [[M2AI alloc] initWithGrid:movedGrid];
                    result = [newAI searchWithPlayerTurn:NO depth:depth - 1 alpha:bestScore beta:beta positions:positions cutoffs:cutoffs];
                    if (result.score > 9900) result.score--;
                    positions = result.positions;
                    cutoffs = result.cutoffs;
                }
                
//                [movedGrid dumpGrid];
//                NSLog(@"Score: %g", result.score);
                
                if (result.score > bestScore) {
                    bestScore = result.score;
                    bestMove = direction;
                }
                
                if (bestScore > beta) {
                    cutoffs++;
                    return [[M2AIResult alloc] initWithMove:bestMove score:beta positions:positions cutoffs:cutoffs];
                }
            }
        }
    } else {
        bestScore = beta;
        NSArray *availableCells = [self.grid availableCells];
        
        NSMutableDictionary *score1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *score2 = [NSMutableDictionary dictionary];
        NSDictionary *scores = @{@1: score1, @2: score2};
        
        for (NSNumber *level in @[@1, @2]) {
            for (M2Cell *availableCell in availableCells) {
                [self.grid insertDummyTileAtPosition:availableCell.position withLevel:level.integerValue];
                NSMutableDictionary *subscore = scores[level];
                subscore[availableCell] = @(-self.grid.smoothness + self.grid.dimension * self.grid.dimension - (availableCells.count - 1));
//                NSLog(@"SUB: %@", subscore[availableCell]);
                [self.grid removeTileAtPosition:availableCell.position];
            }
        }
        
        NSMutableArray *candidates = [NSMutableArray array];
//        double score_1 = [[[scores[@1] allValues] valueForKeyPath:@"@max.self"] doubleValue];
//        double score_2 = [[[scores[@2] allValues] valueForKeyPath:@"@max.self"] doubleValue];
        double maxScore = MAX([[[scores[@1] allValues] valueForKeyPath:@"@max.self"] doubleValue], [[[scores[@2] allValues] valueForKeyPath:@"@max.self"] doubleValue]);
//        NSLog(@"MAX: %g %g %g", score_1, score_2, maxScore);
        for (NSNumber *level in scores) {
            for (M2Cell *cell in scores[level]) {
                double score = [scores[level][cell] doubleValue];
                if (ABS(score - maxScore) < 0.00001) {
                    [candidates addObject:@{@"cell": cell, @"level": level}];
                }
            }
        }
        
        for (NSDictionary *candidateInfo in candidates) {
            M2Grid *newGrid = [self.grid copy];
            [newGrid insertDummyTileAtPosition:[(M2Cell *)candidateInfo[@"cell"] position] withLevel:[candidateInfo[@"level"] integerValue]];
            positions++;
            M2AI *newAI = [[M2AI alloc] initWithGrid:newGrid];
            result = [newAI searchWithPlayerTurn:YES depth:depth alpha:alpha beta:bestScore positions:positions cutoffs:cutoffs];
            positions = result.positions;
            cutoffs = result.cutoffs;
            
            if (result.score < bestScore) {
                bestScore = result.score;
            }
            
            if (bestScore < alpha) {
                cutoffs++;
                return [[M2AIResult alloc] initWithMove:nil score:alpha positions:positions cutoffs:cutoffs];
            }
        }
    }
    return [[M2AIResult alloc] initWithMove:bestMove score:bestScore positions:positions cutoffs:cutoffs];
}

- (M2Vector *)bestMove {
    M2AIResult *newBest;
    for (NSInteger depth = GSTATE.maximumSearchingDepth; depth >= 0 && (!newBest || newBest.score <= -10000); depth--) {
        NSLog(@"Searching at depth %ld...", depth);
        newBest = [self searchWithPlayerTurn:YES depth:depth alpha:-10000 beta:10000 positions:0 cutoffs:0];
    }
    NSLog(@"Score: %g", newBest.score);
    return newBest.move;
}

@end

@implementation M2AIResult

- (id)initWithMove:(M2Vector *)bestMove score:(double)score positions:(NSInteger)positions cutoffs:(NSInteger)cutoffs {
    self = [super init];
    if (self) {
        _move = bestMove;
        _score = score;
        _positions = positions;
        _cutoffs = cutoffs;
    }
    return self;
}

@end