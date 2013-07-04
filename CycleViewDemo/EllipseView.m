//
//  EllipseView.m
//  CycleViewDemo
//
//  Created by Jing on 13-6-20.
//  Copyright (c) 2013年 jing. All rights reserved.
//

#import "EllipseView.h"

@interface EllipseView ()
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    CGFloat a;
    CGFloat b;
    CGFloat c;
    CGFloat d;
    
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    CGFloat a1;
    
    CGFloat singleR;
    CGFloat singleG;
    CGFloat singleB;
    CGFloat singleA;
}

@property (nonatomic) NSTimer *timer;
@property (nonatomic) int startAngle;

@end


@implementation EllipseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _offset = 5;
        _ellipseWidth = 10;
        _ellipseLength = 0.7;
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

#pragma mark - override setter/getter

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self updateEllipseSize];
    [self setNeedsDisplay];
}

- (void)setEllipseWidth:(CGFloat)ellipseWidth
{
    _ellipseWidth = ellipseWidth;
    [self updateEllipseSize];
    [self setNeedsDisplay];
}

- (void)setEllipseLength:(CGFloat)ellipseLength
{
    _ellipseLength = ellipseLength;
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

- (void)updateViewSize
{
    viewWidth = self.bounds.size.width;
    viewHeight = self.bounds.size.height;
    [self updateEllipseSize];
}

- (void)updateEllipseSize
{
    CGFloat l = viewWidth / 2.0 - _offset;
    CGFloat s = viewHeight / 2.0 - _offset;
    
    //椭圆长半径a 和短半径b
    a = viewWidth > viewHeight ? s : l;
    b = viewWidth > viewHeight ? l : s;
    
    CGFloat ll = viewWidth / 2.0 - _offset - _ellipseWidth;
    CGFloat ss = viewHeight / 2.0 - _offset - _ellipseWidth;
    
    c = viewWidth > viewHeight ? ss : ll;
    d = viewWidth > viewHeight ? ll : ss;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGFloat singleAngle = M_PI * 2 * _ellipseLength / _smooth;
        
    for (int i = 0; i < _smooth; i++) {
        
        CGContextSaveGState(context);
     
        CGFloat angle = singleAngle * (self.startAngle + i);
        CGFloat angle1 = singleAngle * (self.startAngle + i + 1);
        
        //fill color
        CGFloat newR = singleR * i + r1;
        CGFloat newG = singleG * i + g1;
        CGFloat newB = singleB * i + b1;
        CGFloat newA = singleA * i + a1;
        UIColor *fillColor = [UIColor colorWithRed:newR green:newG blue:newB alpha:newA];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, viewWidth / 2.0 + a * cos(angle), viewHeight / 2.0 - b * sin(angle));
        CGPathAddLineToPoint(path, NULL, viewWidth / 2.0 + c * cos(angle), viewHeight / 2.0 - d * sin(angle));
        CGPathAddLineToPoint(path, NULL, viewWidth / 2.0 + c * cos(angle1), viewHeight / 2.0 - d * sin(angle1));
        CGPathAddLineToPoint(path, NULL, viewWidth / 2.0 + a * cos(angle1), viewHeight / 2.0 - b * sin(angle1));
        CGPathCloseSubpath(path);
        
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [fillColor CGColor]);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animating) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    [self.timer invalidate];
}

- (void)animating
{
    self.startAngle = self.startAngle + 2;
    [self setNeedsDisplay];
}


@end
