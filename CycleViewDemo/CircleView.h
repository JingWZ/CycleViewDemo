//
//  CircleView.h
//  CycleViewDemo
//
//  Created by Jing on 13-6-18.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property (nonatomic) CGFloat offset;//to bounds

@property (nonatomic) CGFloat circleLength;//0-1
@property (nonatomic) CGFloat circleWidth;

@property (nonatomic) NSUInteger smooth;//8-oo

@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;

@property (nonatomic, getter = isHighlighted) BOOL highlight;
@property (nonatomic) CGFloat highlightSize;
@property (nonatomic) CGFloat highlishtPosition;//0-1

@property (nonatomic, getter = isRound) BOOL round;

- (void)startAnimation;
- (void)stopAnimation;
- (void)pauseAnimation;
- (void)resumeAnimation;

@end
