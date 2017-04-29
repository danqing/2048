//
//  M2Theme.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2Theme.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEX(c)       [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]


@interface M2DefaultTheme : NSObject <M2Theme>
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


@interface M2VibrantTheme : NSObject <M2Theme>
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



@interface M2JoyfulTheme : NSObject <M2Theme>
@end

@implementation M2JoyfulTheme

+ (UIColor *)colorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
      return RGB(236, 243, 251);
    case 2:
      return RGB(230, 245, 252);
    case 3:
      return RGB(95, 131, 157);
    case 4:
      return RGB(164, 232, 254);
    case 5:
      return RGB(226, 246, 209);
    case 6:
      return RGB(237, 228, 253);
    case 7:
      return RGB(254, 224, 235);
    case 8:
      return RGB(254, 235, 115);
    case 9:
      return RGB(255, 249, 136);
    case 10:
      return RGB(208, 246, 247);
    case 11:
      return RGB(251, 244, 236);
    case 12:
      return RGB(254, 237, 229);
    case 13:
      return RGB(205, 247, 235);
    case 14:
      return RGB(57, 120, 104);
    case 15:
    default:
      return RGB(93, 125, 62);
  }
}


+ (UIColor *)textColorForLevel:(NSInteger)level
{
  switch (level) {
    case 1:
      return RGB(104, 119, 131);
    case 2:
      return RGB(70, 128, 161);
    case 3:
      return [UIColor whiteColor];
    case 4:
      return RGB(64, 173, 246);
    case 5:
      return RGB(97, 159, 42);
    case 6:
      return RGB(124, 85, 201);
    case 7:
      return RGB(223, 73, 115);
    case 8:
      return RGB(244, 111, 41);
    case 9:
      return RGB(253, 160, 46);
    case 10:
      return RGB(30, 160, 158);
    case 11:
      return RGB(147, 129, 115);
    case 12:
      return RGB(162, 93, 60);
    case 13:
      return RGB(68, 227, 184);
    case 14:
    case 15:
    default:
      return [UIColor whiteColor];
  }
}


+ (UIColor *)backgroundColor
{
  return RGB(255, 254, 237);
}


+ (UIColor *)boardColor
{
  return RGB(255, 254, 237);
}


+ (UIColor *)scoreBoardColor
{
  return RGB(243, 168, 40);
}


+ (UIColor *)buttonColor
{
  return RGB(242, 79, 46);
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
    case 2:
      return [M2JoyfulTheme class];
    default:
      return [M2DefaultTheme class];
  }
}

@end