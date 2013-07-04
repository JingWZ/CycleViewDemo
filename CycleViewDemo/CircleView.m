//
//  CircleView.m
//  CycleViewDemo
//
//  Created by Jing on 13-6-18.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@interface CircleView ()
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    CGFloat a1;

    CGFloat singleR;
    CGFloat singleG;
    CGFloat singleB;
    CGFloat singleA;
}

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _smooth = 32;
        _offset = 5;
        _circleLength = 0.5;
        [self updateViewSize];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateViewSize];
    [self setNeedsDisplay];
}

- (void)updateViewSize
{
    viewWidth = self.bounds.size.width;
    viewHeight = self.bounds.size.height;
}

#pragma mark - override setter/getter

- (void)setCircleLength:(CGFloat)circleLength
{
    circleLength = circleLength > 1 ? 1 : circleLength;
    circleLength = circleLength < 0 ? 0.5 : circleLength;
    _circleLength = circleLength;
    [self setNeedsDisplay];
}

- (void)setSmooth:(NSUInteger)smooth
{
    smooth = smooth < 2 ? 2 : smooth;
    _smooth = smooth;
    [self setNeedsDisplay];
}

- (void)setOffset:(CGFloat)offset
{
    offset = offset > viewWidth / 2.0 - _circleWidth ? 0 : offset;
    offset = offset < 0 ? 0 : offset;
    _offset = offset;
    [self setNeedsDisplay];
}

- (void)setRound:(BOOL)round
{
    _round = round;
    [self setNeedsDisplay];
}

- (void)setCircleWidth:(CGFloat)circleWidth
{
    circleWidth = circleWidth > viewWidth / 2.0 - _offset ? viewWidth / 2.0 - _offset : circleWidth;
    circleWidth = circleWidth < 0 ? (viewWidth / 2.0 - _offset) / 5.0 : circleWidth;
    _circleWidth = circleWidth;
    [self setNeedsDisplay];
}

- (void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    [self calculateRGBA];
    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    [self calculateRGBA];
    [self setNeedsDisplay];
}

- (void)calculateRGBA {
    
    [_startColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    CGFloat r2 = 0; CGFloat g2 = 0; CGFloat b2 = 0; CGFloat a2 = 0;
    [_endColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    singleR = (r2 - r1) / _smooth;
    singleG = (g2 - g1) / _smooth;
    singleB = (b2 - b1) / _smooth;
    singleA = (a2 - a1) / _smooth;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_circleLength <= 0.5)
    {
        //use linear gradient
        [self drawArcWithStartAngle:0 endAngle:M_PI * 2 * _circleLength round:self.round inContext:context];
        CGContextClip(context);
        
        //gradient
        CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){[_startColor CGColor], [_endColor CGColor]}, 2, NULL);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(viewWidth - _offset, viewHeight / 2.0), CGPointMake(_offset, viewHeight / 2.0), 0);
        
        //release
        CFRelease(colorArray);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    
    else
    {
        CGFloat singleAngle = M_PI * 2 * _circleLength / _smooth;
                
        //custom gradient
        for (int i = 0; i < _smooth; i++)
        {
            CGContextSaveGState(context);
            
            //area
            CGFloat startA = i * singleAngle;
            CGFloat endA = (i + 1) *singleAngle;
            
            if (i == 0) {
                [self drawArcWithStartAngle:startA endAngle:endA round:self.round inContext:context];
            }else{
                [self drawArcWithStartAngle:startA endAngle:endA round:NO inContext:context];
            }
            
            //fill
            CGFloat newR = singleR * i + r1;
            CGFloat newG = singleG * i + g1;
            CGFloat newB = singleB * i + b1;
            CGFloat newA = singleA * i + a1;
            UIColor *fillColor = [UIColor colorWithRed:newR green:newG blue:newB alpha:newA];
            
            CGContextSetFillColorWithColor(context, [fillColor CGColor]);
            CGContextSetStrokeColorWithColor(context, [fillColor CGColor]);
            CGContextDrawPath(context, kCGPathFillStroke);
            
            CGContextRestoreGState(context);
        }
    }
     
}

- (void)drawArcWithStartAngle:(CGFloat)s endAngle:(CGFloat)e round:(BOOL)round inContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    CGContextAddArc(context, viewWidth / 2.0, viewHeight / 2.0, viewWidth / 2.0 - _offset, s, e, 0);
    CGContextAddArc(context, viewWidth / 2.0, viewHeight / 2.0, viewWidth / 2.0 - _offset - _circleWidth, e, s, 1);
    if (round) {
        
        CGContextAddArc(context, viewWidth - _offset - _circleWidth / 2.0, viewHeight / 2.0, _circleWidth / 2.0, 0, M_PI, 1);
        
    }else{
        CGContextClosePath(context);
    }
}

#pragma mark - animation

- (void)startAnimation
{
    CAKeyframeAnimation *a = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    a.removedOnCompletion = NO;
    a.fillMode = kCAFillModeForwards;
    a.repeatCount = HUGE_VALF;
    a.values = @[@0, @-1, @-2, @-3.14, @-4, @-5, @-6.28];
    a.duration = 1;
    [self.layer addAnimation:a forKey:@"transform.rotation.z"];
}

- (void)stopAnimation
{
    [self.layer removeAllAnimations];
}

- (void)pauseAnimation
{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pauseTime;
}

- (void)resumeAnimation
{
    CFTimeInterval pauseTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.layer.beginTime = timeSincePause;
}

@end
