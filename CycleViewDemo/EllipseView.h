//
//  EllipseView.h
//  CycleViewDemo
//
//  Created by Jing on 13-6-20.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EllipseView : UIView

@property (nonatomic) CGFloat offset;//to bounds

@property (nonatomic) CGFloat ellipseLength;//0-1
@property (nonatomic) CGFloat ellipseWidth;

@property (nonatomic) NSUInteger smooth;//8-oo

@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;

- (void)startAnimation;
- (void)stopAnimation;

@end
