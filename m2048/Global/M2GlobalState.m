//
//  M2GlobalState.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2GlobalState.h"
#import "M2Theme.h"

#define kGameType  @"Game Type"
#define kTheme     @"Theme"
#define kBoardSize @"Board Size"
#define kBestScore @"Best Score"

@interface M2GlobalState ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, readwrite) NSInteger winningLevel;
@property (nonatomic, readwrite) NSInteger tileSize;
@property (nonatomic, readwrite) NSInteger borderWidth;
@property (nonatomic, readwrite) NSInteger cornerRadius;
@property (nonatomic, readwrite) NSInteger horizontalOffset;
@property (nonatomic, readwrite) NSInteger verticalOffset;
@property (nonatomic, readwrite) NSTimeInterval animationDuration;
@property (nonatomic, readwrite) M2GameType gameType;
@property (nonatomic) NSInteger theme;

@end


@implementation M2GlobalState

+ (M2GlobalState *)state {
  static M2GlobalState *state = nil;
  
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    state = [[M2GlobalState alloc] init];
  });
  
  return state;
}


- (instancetype)init {
  if (self = [super init]) {
    [self setupDefaultState];
    [self loadGlobalState];
  }
  return self;
}

- (void)setupDefaultState {
  NSDictionary *defaultValues = @{kGameType: @0, kTheme: @0, kBoardSize: @1, kBestScore: @0};
  [Settings registerDefaults:defaultValues];
}

- (void)loadGlobalState {
  self.dimension = [Settings integerForKey:kBoardSize] + 3;
  self.borderWidth = 5;
  self.cornerRadius = 4;
  self.animationDuration = 0.1;
  self.gameType = [Settings integerForKey:kGameType];
  self.horizontalOffset = [self horizontalOffset];
  self.verticalOffset = [self verticalOffset];
  self.theme = [Settings integerForKey:kTheme];
  self.needRefresh = NO;
}


- (NSInteger)tileSize {
  return self.dimension <= 4 ? 66 : 56;
}


- (NSInteger)horizontalOffset {
  CGFloat width = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth;
  return ([[UIScreen mainScreen] bounds].size.width - width) / 2;
}


- (NSInteger)verticalOffset {
  CGFloat height = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth + 120;
  return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}


- (NSInteger)winningLevel {
  if (GSTATE.gameType == M2GameTypePowerOf3) {
    switch (self.dimension) {
      case 3: return 4;
      case 4: return 5;
      case 5: return 6;
      default: return 5;
    }
  }
  
  NSInteger level = 11;
  if (self.dimension == 3) return level - 1;
  if (self.dimension == 5) return level + 2;
  return level;
}


- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2 {
  if (self.gameType == M2GameTypeFibonacci) return abs((int)level1 - (int)level2) == 1;
  return level1 == level2;
}


- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2 {
  if (![self isLevel:level1 mergeableWithLevel:level2]) return 0;
  
  if (self.gameType == M2GameTypeFibonacci) {
    return (level1 + 1 == level2) ? level2 + 1 : level1 + 1;
  }
  return level1 + 1;
}


- (NSInteger)valueForLevel:(NSInteger)level {
  if (self.gameType == M2GameTypeFibonacci) {
    NSInteger a = 1, b = 1;
    for (NSInteger i = 0; i < level; i++) {
      NSInteger c = a + b;
      a = b;
      b = c;
    }
    return b;
  } else {
    NSInteger value = 1;
    NSInteger base = self.gameType == M2GameTypePowerOf2 ? 2 : 3;
    for (NSInteger i = 0; i < level; i++) {
      value *= base;
    }
    return value;
  }
}


# pragma mark - Appearance

- (UIColor *)colorForLevel:(NSInteger)level {
  return [[M2Theme themeClassForType:self.theme] colorForLevel:level];
}


- (UIColor *)textColorForLevel:(NSInteger)level {
  return [[M2Theme themeClassForType:self.theme] textColorForLevel:level];
}


- (CGFloat)textSizeForValue:(NSInteger)value {
  NSInteger offset = self.dimension == 5 ? 2 : 0;
  if (value < 100) {
    return 32 - offset;
  } else if (value < 1000) {
    return 28 - offset;
  } else if (value < 10000) {
    return 24 - offset;
  } else if (value < 100000) {
    return 20 - offset;
  } else if (value < 1000000) {
    return 16 - offset;
  } else {
    return 13 - offset;
  }
}

- (UIColor *)backgroundColor {
  return [[M2Theme themeClassForType:self.theme] backgroundColor];
}


- (UIColor *)scoreBoardColor {
  return [[M2Theme themeClassForType:self.theme] scoreBoardColor];
}


- (UIColor *)boardColor {
  return [[M2Theme themeClassForType:self.theme] boardColor];
}


- (UIColor *)buttonColor {
  return [[M2Theme themeClassForType:self.theme] buttonColor];
}


- (NSString *)boldFontName {
  return [[M2Theme themeClassForType:self.theme] boldFontName];
}


- (NSString *)regularFontName {
  return [[M2Theme themeClassForType:self.theme] regularFontName];
}

# pragma mark - Position to point conversion

- (CGPoint)locationOfPosition:(M2Position)position {
  return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset,
                     [self yLocationOfPosition:position] + self.verticalOffset);
}


- (CGFloat)xLocationOfPosition:(M2Position)position {
  return position.y * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}


- (CGFloat)yLocationOfPosition:(M2Position)position {
  return position.x * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

@end
