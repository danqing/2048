//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2ViewController.h"
#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"

@implementation M2ViewController {
  IBOutlet UIButton *_restartButton;
  IBOutlet UILabel *_targetScore;
  IBOutlet UILabel *_subtitle;
  IBOutlet M2ScoreView *_scoreView;
  IBOutlet M2ScoreView *_bestView;
  
  M2Scene *_scene;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self updateState];
  
  _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
  _restartButton.layer.masksToBounds = YES;
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  
  // Create and configure the scene.
  M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
  [scene startNewGame];
  
  _scene = scene;
}


- (void)updateState
{
  [_scoreView updateAppearance];
  [_bestView updateAppearance];
  
  _restartButton.backgroundColor = [GSTATE buttonColor];
  _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:15];
  
  _targetScore.textColor = [GSTATE buttonColor];
  _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
  
  long target = [GSTATE valueForLevel:GSTATE.winningLevel];
  _targetScore.text = [NSString stringWithFormat:@"%ld", target];
  
  _subtitle.textColor = [GSTATE buttonColor];
  _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:15];
  _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to the %ld tile!", target];
}



- (IBAction)restart:(id)sender
{
  [_scene startNewGame];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

@end
