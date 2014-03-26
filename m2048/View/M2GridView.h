//
//  M2GridView.h
//  m2048
//
//  Created by Danqing on 3/21/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M2Grid;

@interface M2GridView : UIView

+ (UIImage *)gridImageWithGrid:(M2Grid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
