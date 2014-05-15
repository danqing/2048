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

@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, strong) NSMutableDictionary *memoizedResults;

@property (nonatomic, strong) NSString *actions;

@end

@implementation M2AI

- (instancetype)initWithGrid:(M2Grid *)grid {
    self = [super init];
    if (self) {
        _grid = grid;
        _actions = [NSMutableString string];
    }
    return self;
}

- (M2AIResult *)searchWithPlayerTurn:(BOOL)playerTurn depth:(NSInteger)depth alpha:(double)alpha beta:(double)beta positions:(NSInteger)positions cutoffs:(NSInteger)cutoffs {
//    NSAssert(_startTime, nil);
//    NSLog(@"%d %d %f %f %d %d, %g", playerTurn, depth, alpha, beta, positions, cutoffs, ABS([_startTime timeIntervalSinceNow]));
    if (ABS([_startTime timeIntervalSinceNow]) > GSTATE.searchingTimeOut) {
//        NSLog(@"Search timed out: %g", ABS([_startTime timeIntervalSinceNow]));
        return nil;
    }
    double bestScore;
    M2Vector *bestMove;
    M2AIResult *result;
    if (playerTurn) {
        bestScore = alpha;
        for (M2Vector *direction in M2Vectors) {
            if ([self.grid isMovableInDirection:direction]) {
                M2Grid *movedGrid = [self.grid gridAfterMoveInDirection:direction];
                positions++;
                if ([movedGrid isWinningBoard]) {
                    return [[M2AIResult alloc] initWithMove:direction score:10000 positions:positions cutoffs:cutoffs];
                }
                if (depth == 0) {
                    result = [[M2AIResult alloc] initWithMove:direction score:movedGrid.heuristicValue positions:0 cutoffs:0];
                } else {
                    M2AI *newAI = [[M2AI alloc] initWithGrid:movedGrid];
                    newAI.startTime = _startTime;
                    newAI.memoizedResults = _memoizedResults;
                    newAI.actions = [_actions stringByAppendingFormat:@" %@", direction.vectorString];
                    NSString *signature = [NSString stringWithFormat:@"%@ %d %d %g %g", newAI.actions, NO, depth - 1, bestScore, beta];
                    if (_memoizedResults[signature]) {
                        result = _memoizedResults[signature];
//                        NSLog(@"Read memoized: %@", signature);
                    } else {
                        result = [newAI searchWithPlayerTurn:NO depth:depth - 1 alpha:bestScore beta:beta positions:positions cutoffs:cutoffs];
                        if (result) {
                            _memoizedResults[signature] = result;
//                            NSLog(@"Memoized: %@", signature);
                        }
                    }
                    if (result.score >= 9900) result.score--;
                    positions = result.positions;
                    cutoffs = result.cutoffs;
                }
                
                // If timed out, all results are meaningless
                if (!result) return nil;
                
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
                [self.grid removeTileAtPosition:availableCell.position];
            }
        }
        
        NSMutableArray *candidates = [NSMutableArray array];
        double maxScore = MAX([[[scores[@1] allValues] valueForKeyPath:@"@max.self"] doubleValue], [[[scores[@2] allValues] valueForKeyPath:@"@max.self"] doubleValue]);
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
            M2Position candidatePosition = [(M2Cell *)candidateInfo[@"cell"] position];
            [newGrid insertDummyTileAtPosition:candidatePosition withLevel:[candidateInfo[@"level"] integerValue]];
            positions++;
            M2AI *newAI = [[M2AI alloc] initWithGrid:newGrid];
            newAI.startTime = _startTime;
            newAI.memoizedResults = _memoizedResults;
            newAI.actions = [_actions stringByAppendingFormat:@" (%d, %d)", candidatePosition.x, candidatePosition.y];
            NSString *signature = [NSString stringWithFormat:@"%@ %d %d %g %g", newAI.actions, YES, depth, alpha, bestScore];
            if (_memoizedResults[signature]) {
                result = _memoizedResults[signature];
//                NSLog(@"Read memoized: %@", signature);
            } else {
                result = [newAI searchWithPlayerTurn:YES depth:depth alpha:alpha beta:bestScore positions:positions cutoffs:cutoffs];
                if (result) _memoizedResults[signature] = result;
            }
            positions = result.positions;
            cutoffs = result.cutoffs;
            
            // If timed out, all results are meaningless
            if (!result) return nil;
            
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
    _startTime = [NSDate date];
    @autoreleasepool {
        _memoizedResults = [NSMutableDictionary dictionary];
        for (NSInteger depth = 0; depth <= GSTATE.maximumSearchingDepth; depth++) {
            if (ABS([_startTime timeIntervalSinceNow]) > GSTATE.searchingTimeOut) break;
            NSLog(@"Searching at depth %ld...", (long)depth);
            M2AIResult *result = [self searchWithPlayerTurn:YES depth:depth alpha:-10000 beta:10000 positions:0 cutoffs:0];
            if (result && (!newBest || result.score >= newBest.score)) {
                newBest = result;
                NSLog(@"** New score at depth %ld: %g **", (long)depth, newBest.score);
            }
            if (!result) NSLog(@"Searching timed out at depth %ld", (long)depth);
            NSLog(@"Time taken: %g", ABS([_startTime timeIntervalSinceNow]));
        }
        [_memoizedResults removeAllObjects];
    }
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