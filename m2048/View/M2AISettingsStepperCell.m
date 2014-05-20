//
//  M2AISettingsStepperCell.m
//  m2048
//
//  Created by Sihao Lu on 5/15/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AISettingsStepperCell.h"

NSString *M2AISettingsStepperCellIdentifier = @"AI Stepper Cell";

@interface M2AISettingsStepperCell ()

@property (nonatomic, weak) IBOutlet UILabel *stepperValueLabel;

- (IBAction)stepperValueChanged:(id)sender;

@end

@implementation M2AISettingsStepperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.stepperValueLabel.text = [NSString stringWithFormat:@"%g", self.stepper.value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStepperMin:(double)min max:(double)max current:(double)current step:(double)step {
    self.stepper.minimumValue = min;
    self.stepper.maximumValue = max;
    self.stepper.value = current;
    self.stepper.stepValue = step;
    self.stepperValueLabel.text = [NSString stringWithFormat:@"%g", self.stepper.value];
    [self.delegate stepperValueChanged:self.stepper.value sender:self];
}

- (IBAction)stepperValueChanged:(id)sender {
    self.stepperValueLabel.text = [NSString stringWithFormat:@"%g", self.stepper.value];
    [self.delegate stepperValueChanged:self.stepper.value sender:self];
}

@end
