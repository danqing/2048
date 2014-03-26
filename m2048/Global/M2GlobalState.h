//
//  M2GlobalState.h
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2Position.h"

#define GSTATE [M2GlobalState state]
#define Settings [NSUserDefaults standardUserDefaults]
#define NotifCtr [NSNotificationCenter defaultCenter]

typedef NS_ENUM(NSInteger, M2GameType) {
  M2GameTypeFibonacci = 2,
  M2GameTypePowerOf2 = 0,
  M2GameTypePowerOf3 = 1
};

@interface M2GlobalState : NSObject

@property (nonatomic, readonly) NSInteger dimension;
@property (nonatomic, readonly) NSInteger winningLevel;
@property (nonatomic, readonly) NSInteger tileSize;
@property (nonatomic, readonly) NSInteger borderWidth;
@property (nonatomic, readonly) NSInteger cornerRadius;
@property (nonatomic, readonly) NSInteger horizontalOffset;
@property (nonatomic, readonly) NSInteger verticalOffset;
@property (nonatomic, readonly) NSTimeInterval animationDuration;
@property (nonatomic, readonly) M2GameType gameType;

@property (nonatomic) BOOL needRefresh;

/** The singleton instance of state. */
+ (M2GlobalState *)state;

/** Refreshes global state to reflect user choice. */
- (void)loadGlobalState;

/**
 * Whether the two levels can merge with each other to form another level. 
 * This behavior is commutative.
 *
 * @param level1 The first level.
 * @param level2 The second level.
 * @return YES if the two levels are actionable with each other.
 */
- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2;

/**
 * The resulting level of merging the two incoming levels.
 *
 * @param level1 The first level.
 * @param level2 The second level.
 * @return The resulting level, or 0 if the two levels are not actionable.
 */
- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2;

/**
 * The numerical value of the specified level.
 *
 * @param level The level we are interested in.
 * @return The numerical value of the level.
 */
- (NSInteger)valueForLevel:(NSInteger)level;

/**
 * The background color of the specified level.
 *
 * @param level The level we are interested in.
 * @return The color of the level.
 */
- (UIColor *)colorForLevel:(NSInteger)level;

/**
 * The text color of the specified level.
 *
 * @param level The level we are interested in.
 * @return The color of the level.
 */
- (UIColor *)textColorForLevel:(NSInteger)level;

- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regularFontName;

/**
 * The text size of the specified value.
 *
 * @param value The value we are interested in.
 * @return The text size of the value.
 */
- (CGFloat)textSizeForValue:(NSInteger)value;

/**
 * The starting location of the position.
 *
 * @param position The position we are interested in.
 * @return The location in points, relative to the grid.
 */
- (CGPoint)locationOfPosition:(M2Position)position;

/**
 * The starting x location of the position.
 *
 * @param position The position we are interested in.
 * @return The x location in points, relative to the grid.
 */
- (CGFloat)xLocationOfPosition:(M2Position)position;

/**
 * The starting y location of the position.
 *
 * @param position The position we are interested in.
 * @return The y location in points, relative to the grid.
 */
- (CGFloat)yLocationOfPosition:(M2Position)position;


- (CGVector)distanceFromPosition:(M2Position)oldPosition toPosition:(M2Position)newPosition;

@end
