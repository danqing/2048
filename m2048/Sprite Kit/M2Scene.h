//
//  M2Scene.h
//  m2048
//

//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class M2Grid;

@interface M2Scene : SKScene

- (void)startNewGame;

- (void)loadBoardWithGrid:(M2Grid *)grid;

@end
