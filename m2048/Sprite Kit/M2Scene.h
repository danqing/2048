//
//  M2Scene.h
//  m2048
//

//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class M2Grid;
@class M2ViewController;

@interface M2Scene : SKScene

@property (nonatomic, weak) M2ViewController *delegate;

- (void)startNewGame;

- (void)loadBoardWithGrid:(M2Grid *)grid;
- (void)undo;
@end
