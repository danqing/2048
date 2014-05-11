//
//  M2Tile.h
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "M2Tile.h"

@interface M2DisplayTile : SKShapeNode <M2Tile>

- (void)commitPendingActions;

/**
 * Removes the tile from its cell and from the scene.
 *
 * @param animated If YES, the removal will be animated.
 */
- (void)removeAnimated:(BOOL)animated;

@end
