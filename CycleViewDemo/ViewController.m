//
//  ViewController.m
//  CycleViewDemo
//
//  Created by Jing on 13-6-14.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CircleView *circleView;

@end

@implementation ViewController

#pragma mark - circle

- (IBAction)start:(id)sender {
    
    [self.circleView startAnimation];
}

- (IBAction)stop:(id)sender {
    
    [self.circleView stopAnimation];
}

- (IBAction)pause:(id)sender {
    [self.circleView pauseAnimation];
}

- (IBAction)resume:(id)sender {
    [self.circleView resumeAnimation];
}

- (void)showCircleView
{
    [self.circleView setOffset:10.0];
    [self.circleView setCircleWidth:15.0];
    [self.circleView setCircleLength:0.8];
    [self.circleView setSmooth:486];
    [self.circleView setRound:YES];
    [self.circleView setStartColor:[UIColor redColor]];
    [self.circleView setEndColor:[UIColor yellowColor]];
}

#pragma mark - VC lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showCircleView];
}

@end
