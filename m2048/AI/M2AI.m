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
#import "M2Vector.h"

@interface M2AI ()

@property M2Grid *grid;

@end

@implementation M2AI

- (instancetype)initWithGrid:(M2Grid *)grid {
    self = [super init];
    if (self) {
        _grid = grid;
    }
    return self;
}

- (M2AIResult *)searchWithPlayerTurn:(BOOL)playerTurn depth:(NSInteger)depth alpha:(double)alpha beta:(double)beta positions:(NSInteger)positions cutoffs:(NSInteger)cutoffs {
//    var bestScore;
//    var bestMove = -1;
//    var result;
//    
//    // the maxing player
//    if (this.grid.playerTurn) {
//        bestScore = alpha;
//        for (var direction in [0, 1, 2, 3]) {
//            var newGrid = this.grid.clone();
//            if (newGrid.move(direction).moved) {
//                positions++;
//                if (newGrid.isWin()) {
//                    return { move: direction, score: 10000, positions: positions, cutoffs: cutoffs };
//                }
//                var newAI = new AI(newGrid);
//                
//                if (depth == 0) {
//                    result = { move: direction, score: newAI.eval() };
//                } else {
//                    result = newAI.search(depth-1, bestScore, beta, positions, cutoffs);
//                    if (result.score > 9900) { // win
//                        result.score--; // to slightly penalize higher depth from win
//                    }
//                    positions = result.positions;
//                    cutoffs = result.cutoffs;
//                }
//                
//                if (result.score > bestScore) {
//                    bestScore = result.score;
//                    bestMove = direction;
//                }
//                if (bestScore > beta) {
//                    cutoffs++
//                    return { move: bestMove, score: beta, positions: positions, cutoffs: cutoffs };
//                }
//            }
//        }
//    }
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
                
                if (result.score > bestScore) {
                    bestScore = result.score;
                    bestMove = result.move;
                }
                
                if (bestScore > beta) {
                    cutoffs++;
                    return [[M2AIResult alloc] initWithMove:bestMove score:beta positions:positions cutoffs:cutoffs];
                }
            }
        }
    } else {
//        else { // computer's turn, we'll do heavy pruning to keep the branching factor low
//            bestScore = beta;
//            
//            // try a 2 and 4 in each cell and measure how annoying it is
//            // with metrics from eval
//            var candidates = [];
//            var cells = this.grid.availableCells();
//            var scores = { 2: [], 4: [] };
//            for (var value in scores) {
//                for (var i in cells) {
//                    scores[value].push(null);
//                    var cell = cells[i];
//                    var tile = new Tile(cell, parseInt(value, 10));
//                    this.grid.insertTile(tile);
//                    scores[value][i] = -this.grid.smoothness() + this.grid.islands();
//                    this.grid.removeTile(cell);
//                }
//            }
        bestScore = beta;
        NSArray *availableCells = [self.grid availableCells];
        
        NSMutableDictionary *score1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *score2 = [NSMutableDictionary dictionary];
        NSDictionary *scores = @{@1: score1, @2: score2};
        
        for (NSNumber *level in @[@1, @2]) {
            for (M2Cell *availableCell in availableCells) {
                [self.grid insertTileAtPosition:availableCell.position withLevel:level.integerValue];
                NSMutableDictionary *subscore = scores[level];
                subscore[availableCell] = @(-self.grid.smoothness + self.grid.dimension * self.grid.dimension - availableCells.count);
                [self.grid removeTileAtPosition:availableCell.position];
            }
        }
        
//        // now just pick out the most annoying moves
//        var maxScore = Math.max(Math.max.apply(null, scores[2]), Math.max.apply(null, scores[4]));
//        for (var value in scores) { // 2 and 4
//            for (var i=0; i<scores[value].length; i++) {
//                if (scores[value][i] == maxScore) {
//                    candidates.push( { position: cells[i], value: parseInt(value, 10) } );
//                }
//            }
//        }
        
        NSMutableArray *candidates = [NSMutableArray array];
        double maxScore = MAX([[scores[@1] valueForKeyPath:@"@max.self"] doubleValue], [[scores[@2] valueForKeyPath:@"@max.self"] doubleValue]);
        for (NSNumber *level in scores) {
            for (M2Cell *cell in scores[level]) {
                double score = [scores[level][cell] doubleValue];
                if (score == maxScore) {
                    [candidates addObject:@{@"cell": cell, @"level": level}];
                }
            }
        }
        
//        
//        // search on each candidate
//        for (var i=0; i<candidates.length; i++) {
//            var position = candidates[i].position;
//            var value = candidates[i].value;
//            var newGrid = this.grid.clone();
//            var tile = new Tile(position, value);
//            newGrid.insertTile(tile);
//            newGrid.playerTurn = true;
//            positions++;
//            newAI = new AI(newGrid);
//            result = newAI.search(depth, alpha, bestScore, positions, cutoffs);
//            positions = result.positions;
//            cutoffs = result.cutoffs;
//            
//            if (result.score < bestScore) {
//                bestScore = result.score;
//            }
//            if (bestScore < alpha) {
//                cutoffs++;
//                return { move: null, score: alpha, positions: positions, cutoffs: cutoffs };
//            }
//        }
        
        for (NSDictionary *candidateInfo in candidates) {
            M2Grid *newGrid = [self.grid copy];
            [newGrid insertTileAtPosition:[(M2Cell *)candidateInfo[@"cell"] position] withLevel:[candidateInfo[@"level"] integerValue]];
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
//      return { move: bestMove, score: bestScore, positions: positions, cutoffs: cutoffs };
    return [[M2AIResult alloc] initWithMove:bestMove score:bestScore positions:positions cutoffs:cutoffs];
}

- (M2Vector *)bestMove {
    M2AIResult *newBest = [self searchWithPlayerTurn:YES depth:3 alpha:-10000 beta:10000 positions:0 cutoffs:0];
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