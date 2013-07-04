//
//  ViewController.m
//  CycleViewDemo
//
//  Created by Jing on 13-6-14.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import "EllipseView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CircleView *circleView;
@property (weak, nonatomic) IBOutlet EllipseView *ellipseView;
@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;


@end

@implementation ViewController


- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    [self.ellipseView setEllipseLength:[sender value]];
}

#pragma mark - ellipse

- (void)showEllipseView
{
    [self.ellipseView setOffset:10.0];
    [self.ellipseView setEllipseWidth:12.0];
    [self.ellipseView setEllipseLength:1.];
    [self.ellipseView setSmooth:100];
    [self.ellipseView setStartColor:[UIColor yellowColor]];
    [self.ellipseView setEndColor:[UIColor redColor]];

}

- (IBAction)startEllipse:(id)sender {
    [self.ellipseView startAnimation];
}

- (IBAction)stopEllipse:(id)sender {
    [self.ellipseView stopAnimation];
}

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
    [self.circleView setSmooth:100];
    [self.circleView setRound:YES];
    [self.circleView setStartColor:[UIColor redColor]];
    [self.circleView setEndColor:[UIColor yellowColor]];
    
    //self.circleView.layer setTransform:ca
}

#pragma mark - VC lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showCircleView];
    [self showEllipseView];
}

@end
