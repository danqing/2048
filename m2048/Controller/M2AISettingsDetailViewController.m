//
//  M2AISettingsDetailViewController.m
//  m2048
//
//  Created by Sihao Lu on 5/15/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AISettingsDetailViewController.h"
#import "M2AISettingsStepperCell.h"

@interface M2AISettingsDetailViewController () <M2AISettingsStepperDelegate>

@end

@implementation M2AISettingsDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stepper Delegate
- (void)stepperValueChanged:(double)newValue sender:(id)sender {
    if ([sender tag] == 0) {
        [Settings setDouble:newValue forKey:M2AIMaxSearchDepthKey];
    } else {
        [Settings setDouble:newValue forKey:M2AIMaxSearchTimeKey];
    }
    GSTATE.needRefresh = YES;
}

#pragma mark - Switch Event
- (void)switchValueChanged:(UISwitch *)sender {
    [Settings setBool:sender.isOn forKey:M2AICacheResultsKey];
    GSTATE.needRefresh = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [@[@2, @1][section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        M2AISettingsStepperCell *cell = (M2AISettingsStepperCell *)[tableView dequeueReusableCellWithIdentifier:M2AISettingsStepperCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.tag = indexPath.row;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Max Search Depth";
            [cell setStepperMin:0 max:10 current:[Settings doubleForKey:M2AIMaxSearchDepthKey] step:1];
        } else {
            cell.titleLabel.text = @"Max Search Time";
            [cell setStepperMin:1 max:60 current:[Settings doubleForKey:M2AIMaxSearchTimeKey] step:1];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AI Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"Cache Results";
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[Settings boolForKey:M2AICacheResultsKey] animated:NO];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    return @"Performance";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @[@"The Maximum Search Depth indicates how many steps the AI thinks forward each time. The time it costs for each additional depth grows exponentially. When reaching the Maximum Search Time and the searching is still in progress, the AI stops the search and makes the best move searched so far.",
             @"Caching the results improves performance when search depth is high (typically above or equal to 3)."][section];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
