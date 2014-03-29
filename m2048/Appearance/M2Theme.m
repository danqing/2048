//
//  M2Theme.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Theme.h"

#define RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEX(c)           [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]


@interface M2DefaultTheme : M2Theme
@end

@implementation M2DefaultTheme

+ (UIColor *)colorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
      return RGB(238, 228, 218);
    case 2:
      return RGB(237, 224, 200);
    case 3:
      return RGB(242, 177, 121);
    case 4:
      return RGB(245, 149, 99);
    case 5:
      return RGB(246, 124, 95);
    case 6:
      return RGB(246, 94, 59);
    case 7:
      return RGB(237, 207, 114);
    case 8:
      return RGB(237, 204, 97);
    case 9:
      return RGB(237, 200, 80);
    case 10:
      return RGB(237, 197, 63);
    case 11:
      return RGB(237, 194, 46);
    case 12:
      return RGB(173, 183, 119);
    case 13:
      return RGB(170, 183, 102);
    case 14:
      return RGB(164, 183, 79);
    case 15:
      return RGB(161, 183, 63);
    default:
      return RGB(161, 183, 63);
  }
}


+ (UIColor *)textColorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
    case 2:
      return RGB(118, 109, 100);
    default:
      return [UIColor whiteColor];
  }
}


+ (UIColor *)backgroundColor
{
  return RGB(250, 248, 239);
}


+ (UIColor *)boardColor
{
  return RGB(204, 192, 179);
}


+ (UIColor *)scoreBoardColor
{
  return RGB(187, 173, 160);
}


+ (UIColor *)buttonColor
{
  return RGB(119, 110, 101);
}


+ (NSString *)boldFontName
{
  return @"AvenirNext-DemiBold";
}


+ (NSString *)regularFontName
{
  return @"AvenirNext-Regular";
}

@end


@interface M2VibrantTheme : M2Theme
@end

@implementation M2VibrantTheme

+ (UIColor *)colorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
      return RGB(254, 223, 180);
    case 2:
      return RGB(254, 183, 143);
    case 3:
      return RGB(253, 187, 45);
    case 4:
      return RGB(253, 157, 40);
    case 5:
      return RGB(246, 124, 95);
    case 6:
      return RGB(217, 70, 119);
    case 7:
      return RGB(210, 65, 97);
    case 8:
      return RGB(207, 50, 90);
    case 9:
      return RGB(205, 35, 84);
    case 10:
      return RGB(200, 30, 78);
    case 11:
      return RGB(190, 20, 70);
    case 12:
      return RGB(254, 233, 78);
    case 13:
      return RGB(249, 191, 64);
    case 14:
      return RGB(247, 167, 56);
    case 15:
      return RGB(244, 138, 48);
    default:
      return RGB(244, 138, 48);
  }
}


+ (UIColor *)textColorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
    case 2:
      return RGB(150, 110, 90);
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
      return [UIColor whiteColor];
    default:
      return [UIColor whiteColor];
  }
}


+ (UIColor *)backgroundColor
{
  return RGB(240, 240, 240);
}


+ (UIColor *)boardColor
{
  return RGB(240, 240, 240);
}


+ (UIColor *)scoreBoardColor
{
  return RGB(253, 144, 38);
}


+ (UIColor *)buttonColor
{
  return RGB(205, 35, 85);
}


+ (NSString *)boldFontName
{
  return @"AvenirNext-DemiBold";
}


+ (NSString *)regularFontName
{
  return @"AvenirNext-Regular";
}

@end



@interface M2MinimalismTheme : M2Theme
@end

@implementation M2MinimalismTheme

+ (UIColor *)colorForLevel:(NSInteger)level
{
  return RGB(245, 245, 245);
}


+ (UIColor *)textColorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
      return RGB(223, 34, 1);
    case 2:
      return RGB(231, 68, 0);
    case 3:
      return RGB(242, 177, 121);
    case 4:
      return RGB(245, 149, 99);
    case 5:
      return RGB(246, 124, 95);
    case 6:
      return RGB(246, 94, 59);
    case 7:
      return RGB(237, 207, 114);
    case 8:
      return RGB(237, 204, 97);
    case 9:
      return RGB(131, 178, 7);
    case 10:
      return RGB(124, 175, 2);
    case 11:
      return RGB(116, 171, 0);
    case 12:
      return RGB(107, 168, 0);
    case 13:
      return RGB(99, 164, 0);
    case 14:
      return RGB(90, 160, 0);
    case 15:
      return RGB(82, 157, 0);
    default:
      return RGB(30, 30, 30);
  }
}


+ (UIColor *)backgroundColor
{
  return RGB(240, 240, 240);
}


+ (UIColor *)boardColor
{
  return RGB(240, 240, 240);
}


+ (UIColor *)scoreBoardColor
{
  return RGB(58, 171, 115);
}


+ (UIColor *)buttonColor
{
  return RGB(31, 177, 252);
}


+ (NSString *)boldFontName
{
  return @"AvenirNext-DemiBold";
}


+ (NSString *)regularFontName
{
  return @"AvenirNext-Regular";
}

@end


@implementation M2Theme

+ (Class)themeClassForType:(NSInteger)type
{
  switch (type) {
    case 1:
      return [M2VibrantTheme class];
    default:
      return [M2DefaultTheme class];
  }
}

/* None of these should be called. */
// @TODO Change M2Theme into a protocol.

+ (UIColor *)colorForLevel:(NSInteger)level {return [UIColor whiteColor]; }
+ (UIColor *)textColorForLevel:(NSInteger)level {return [UIColor whiteColor]; }
+ (UIColor *)backgroundColor {return [UIColor whiteColor]; }
+ (UIColor *)boardColor {return [UIColor whiteColor]; }
+ (UIColor *)borderColor {return [UIColor whiteColor]; }
+ (UIColor *)scoreBoardColor {return [UIColor whiteColor]; }
+ (UIColor *)buttonColor {return [UIColor whiteColor]; }
+ (NSString *)boldFontName {return @""; }
+ (NSString *)regularFontName {return @""; }

@end