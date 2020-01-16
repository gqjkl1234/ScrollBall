//
//  ViewController.m
//  NestScrollViewTest
//
//  Created by ww on 2019/11/15.
//  Copyright © 2019 ww. All rights reserved.
//

#import "ViewController.h"

#define INNTER_SIDE_LENGTH 32.0f
#define OUTTER_SIDE_LENGTH 128.0f

@interface ViewController () {
    CGPoint orignalPoint;
}

@property (nonatomic, strong) UIView *ballV;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _ballV = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, INNTER_SIDE_LENGTH, INNTER_SIDE_LENGTH)];
    _ballV.layer.cornerRadius = INNTER_SIDE_LENGTH * 0.5;
    _ballV.backgroundColor = UIColor.redColor;
    _ballV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:_ballV];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 1;
    _shapeLayer.fillColor = UIColor.clearColor.CGColor;
    _shapeLayer.strokeColor = UIColor.lightGrayColor.CGColor;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.path = [self pathWithBallV].CGPath;
    [self.view.layer insertSublayer:_shapeLayer below:_ballV.layer];
}

- (UIBezierPath *)pathWithBallV {
    
    CGRect frame = _ballV.frame;
    
    CGFloat radius = sqrtf(2.0f) * INNTER_SIDE_LENGTH * 0.5;
    CGPoint center = CGPointMake(frame.origin.x + frame.size.width * 0.5, frame.origin.y + frame.size.height * 0.5);
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-3 * M_PI_4 endAngle:-M_PI_4 clockwise:YES]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:3 * M_PI_4 endAngle:M_PI_4 clockwise:NO]];

    CGFloat offset = (sqrtf(2.0f) * OUTTER_SIDE_LENGTH * 0.5 - radius) / (1 + sqrtf(2.0f));
    CGPoint newCenter = CGPointMake(center.x - 0.5 * OUTTER_SIDE_LENGTH + offset, center.y - 0.5 * OUTTER_SIDE_LENGTH + offset);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:newCenter radius:offset startAngle:M_PI_2 endAngle:M_PI_4 clockwise:NO]];
    newCenter = CGPointMake(newCenter.x, newCenter.y + offset);
    [path moveToPoint:CGPointMake(0.0, newCenter.y)];
    [path addLineToPoint:newCenter];
    
    newCenter = CGPointMake(center.x - 0.5 * OUTTER_SIDE_LENGTH + offset, center.y + 0.5 * OUTTER_SIDE_LENGTH - offset);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:newCenter radius:offset startAngle:-M_PI_2 endAngle:-M_PI_4 clockwise:YES]];
    newCenter = CGPointMake(newCenter.x, newCenter.y - offset);
    [path moveToPoint:CGPointMake(0.0, newCenter.y)];
    [path addLineToPoint:newCenter];

    newCenter = CGPointMake(center.x + 0.5 * OUTTER_SIDE_LENGTH - offset, center.y - 0.5 * OUTTER_SIDE_LENGTH + offset);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:newCenter radius:offset startAngle:3 * M_PI_4 endAngle:M_PI_2 clockwise:NO]];
    newCenter = CGPointMake(newCenter.x, newCenter.y + offset);
    [path moveToPoint:newCenter];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, newCenter.y)];

    newCenter = CGPointMake(center.x + 0.5 * OUTTER_SIDE_LENGTH - offset, center.y + 0.5 * OUTTER_SIDE_LENGTH - offset);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:newCenter radius:offset startAngle:-M_PI_2 endAngle:-3 * M_PI_4 clockwise:NO]];
    newCenter = CGPointMake(newCenter.x, newCenter.y - offset);
    [path moveToPoint:newCenter];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, newCenter.y)];

    return path;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    orignalPoint = CGPointZero;
    CGPoint touchPoint = [touches.anyObject locationInView:self.view];
    if (CGRectContainsPoint(self.ballV.frame, touchPoint)) {
        orignalPoint = touchPoint;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (CGPointEqualToPoint(orignalPoint, CGPointZero)) {
        return;
    }
    [self updateBallWith:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (CGPointEqualToPoint(orignalPoint, CGPointZero)) {
        return;
    }
    [self updateBallWith:touches];
    orignalPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (CGPointEqualToPoint(orignalPoint, CGPointZero)) {
        return;
    }
    [self updateBallWith:touches];
    orignalPoint = CGPointZero;
}

- (void)updateBallWith:(NSSet<UITouch *> *)touches {
    
    CGPoint movePoint = [touches.anyObject locationInView:self.view];
    CGRect frame = self.ballV.frame;
    CGFloat x = frame.origin.x + movePoint.x - orignalPoint.x;
    if (x < frame.size.width * 0.5) {
        x = 0;
    }
    
    if (x > self.view.frame.size.width - frame.size.width * 0.5) {
        x = self.view.frame.size.width - frame.size.width * 0.5;
    }
    frame.origin.x = x;
    self.ballV.frame = frame;
    _shapeLayer.path = [self pathWithBallV].CGPath;
    
    orignalPoint = movePoint;
}
@end
