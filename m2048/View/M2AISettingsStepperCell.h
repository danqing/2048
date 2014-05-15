//
//  M2AISettingsStepperCell.h
//  m2048
//
//  Created by Sihao Lu on 5/15/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *M2AISettingsStepperCellIdentifier;

@protocol M2AISettingsStepperDelegate <NSObject>

- (void)stepperValueChanged:(double)newValue sender:(id)sender;

@end

@interface M2AISettingsStepperCell : UITableViewCell

@property (nonatomic, weak) id <M2AISettingsStepperDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIStepper *stepper;

- (void)setStepperMin:(double)min max:(double)max current:(double)current step:(double)step;

@end
