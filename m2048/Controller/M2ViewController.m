//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2ViewController.h"
#import "M2SettingsViewController.h"

#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"
#import "M2Overlay.h"
#import "M2GridView.h"
#import "M2Vector.h"
#import <M13ProgressViewBar.h>

@implementation M2ViewController {
    IBOutlet UIButton *_restartButton;
    IBOutlet UIButton *_settingsButton;
    IBOutlet UIButton *_showHintButton;
    IBOutlet UIButton *_autoRunButton;

    IBOutlet UILabel *_targetScore;
    IBOutlet UILabel *_subtitle;
    IBOutlet M2ScoreView *_scoreView;
    IBOutlet M2ScoreView *_bestView;
    
    M2Scene *_scene;
    
    IBOutlet M2Overlay *_overlay;
    IBOutlet UIImageView *_overlayBackground;
    
    IBOutlet M13ProgressViewBar *_AIProgressView;
    IBOutlet UILabel *_AIProgressLabel;
    NSTimer *_progressTimer;
    NSDate *_startTime;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
    
    NSArray *buttons = @[_restartButton, _settingsButton, _showHintButton, _autoRunButton];
    
    for (UIButton *button in buttons) {
        button.layer.cornerRadius = [GSTATE cornerRadius];
        button.layer.masksToBounds = YES;
    }
    
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.delegate = self;
    
    // Add observers for AI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hintResultAvailable:) name:M2AIHintCompleteNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRunComplete:) name:M2AIAutoRunCompleteNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRunStep:) name:M2AIAutoRunStepNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRunThinking:) name:M2AISearchDepthCompleteNotificationName object:nil];

    // AI progress bar
    _AIProgressView.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)updateState
{
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    NSArray *buttons = @[_restartButton, _settingsButton, _showHintButton, _autoRunButton];
    
    for (UIButton *button in buttons) {
        button.backgroundColor = [GSTATE buttonColor];
        button.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    }
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winningLevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    } else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    } else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat:@"%ld", target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!", target];
    
    _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
    _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    
    // Hide AI buttons when game mode is not compatible
    [@[_showHintButton, _autoRunButton] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIButton *)obj setHidden:GSTATE.gameType != M2GameTypePowerOf2];
    }];
}


- (void)updateScore:(NSInteger)score
{
    _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    if ([Settings integerForKey:@"Best Score"] < score) {
        [Settings setInteger:score forKey:@"Best Score"];
        _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
    ((SKView *)self.view).paused = YES;
}


- (IBAction)restart:(id)sender
{
    [self hideOverlay];
    [self updateScore:0];
    [_scene startNewGame];
    [self resetAI];
    
}


- (IBAction)keepPlaying:(id)sender
{
    [self hideOverlay];
    
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    ((SKView *)self.view).paused = NO;
    if (GSTATE.needRefresh) {
        [GSTATE loadGlobalState];
        [self updateState];
        [self updateScore:0];
        [_scene startNewGame];
    }
    [self resetAI];
}

- (void)endGameWinning:(BOOL)won
{
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
    
    // Stop AI
    if ([_scene isAutoRunning])[_scene toggleAutoRun];
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        _overlay.message.text = @"Game Over";
    } else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"You Win!";
    }
    
    // Fake the overlay background as a mask on the board.
    _overlayBackground.image = [M2GridView gridImageWithOverlay];
    
    // Center the overlay in the board.
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
    
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        _overlayBackground.alpha = 1;
    } completion:^(BOOL finished) {
        // Freeze the current game.
        ((SKView *)self.view).paused = YES;
    }];
    
    [self resetAI];
    
}


- (void)hideOverlay
{
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished) {
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - AI

- (void)resetAI {
    if ([_scene isAutoRunning])[_scene toggleAutoRun];
    [_autoRunButton setTitle:@"Auto Run" forState:UIControlStateNormal];
    [self enableControls:YES];
    [self resetProgressBar];
}

- (void)resetProgressBar {
    [_AIProgressView setProgress:0 animated:NO];
    _startTime = [NSDate date];
}

- (void)updateProgressBar:(NSTimer *)sender {
    [_AIProgressView setProgress:MIN(1, ABS([_startTime timeIntervalSinceNow]) / GSTATE.searchTimeOut) animated:YES];
}

- (void)enableControls:(BOOL)enableControls {
    _scene.userInteractionEnabled = enableControls;
    _restartButton.enabled = enableControls;
    _settingsButton.enabled = enableControls;
    _startTime = [NSDate date];
    if (!enableControls) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];
    } else {
        [_progressTimer invalidate];
        [_AIProgressView setProgress:0 animated:NO];
    }
    _AIProgressView.hidden = enableControls;
    _AIProgressLabel.hidden = enableControls;
    
    // Set idle timer disabled if AI is running
    [[UIApplication sharedApplication] setIdleTimerDisabled:!enableControls];
}

- (IBAction)autoRun:(id)sender {
    [_scene toggleAutoRun];
    [self enableControls:![_scene isAutoRunning]];
    _showHintButton.enabled = ![_scene isAutoRunning];
    
    if ([_scene isAutoRunning]) {
        [_autoRunButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [_autoRunButton setTitle:@"Auto Run" forState:UIControlStateNormal];
    }
}

- (IBAction)showHint:(id)sender {
    [_scene showHint];
    _startTime = [NSDate date];
    [self enableControls:NO];
    _autoRunButton.enabled = NO;
}

- (void)hintResultAvailable:(NSNotification *)notification {
    [self enableControls:YES];
    [self resetProgressBar];
    _autoRunButton.enabled = YES;
    if ([[notification userInfo][@"bestMove"] isEqual:[NSNull null]]) {
        NSLog(@"No best move found.");
        return;
    }
    M2Vector *move = [notification userInfo][@"bestMove"];
    UIImageView *hintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ios7-arrow-thin-%@", move.vectorString.lowercaseString]]];
    hintImageView.frame = CGRectMake(32, 196, 256, 256);
    hintImageView.alpha = 0;
    [self.view addSubview:hintImageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        hintImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.4 options:0 animations:^{
            hintImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [hintImageView removeFromSuperview];
        }];
    }];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:[NSString stringWithFormat:@"You should move %@.", move.vectorString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}

- (void)autoRunThinking:(NSNotification *)notification {
    NSLog(@"Thinking updated");
    NSInteger depth = [[notification userInfo][@"depth"] integerValue];
    _AIProgressLabel.text = [NSString stringWithFormat:@"Thinking %ld steps forward...", (long)depth];
}

- (void)autoRunStep:(NSNotification *)notification {
    [self resetProgressBar];
}

- (void)autoRunComplete:(NSNotification *)notification {
    [self enableControls:YES];
    _showHintButton.enabled = YES;
}

@end
