//
//  CTViewController.m
//  CubeTransition
//
//  Created by OHKI Yoshihito on 11/5/12.
//  Copyright (c) 2012 Veronica Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CTViewController.h"

@interface CTViewController ()

@end

@implementation CTViewController

CALayer *_parent;
CALayer *_layer1;
CALayer *_layer2;
CALayer *_layer3;
CALayer *_layer4;

CATransform3D _front;
CATransform3D _right;
CATransform3D _left;
CATransform3D _back;

CGPoint _touch;
CGFloat _frontRad = 0;

#define CUBE_WIDTH 320
#define CUBE_HEIGHT 400

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    CATransform3D r;
    CATransform3D t;
    _front = CATransform3DMakeTranslation(0, 0, 0);
    
    r = CATransform3DMakeRotation(M_PI * 0.5, 0, 1, 0);
    t = CATransform3DMakeTranslation(CUBE_WIDTH / 2, 0, -CUBE_WIDTH / 2);
    _right = CATransform3DConcat(r, t);
    
    r = CATransform3DMakeRotation(-M_PI * 0.5, 0, 1, 0);
    t = CATransform3DMakeTranslation(-CUBE_WIDTH / 2, 0, -CUBE_WIDTH / 2);
    _left = CATransform3DConcat(r, t);

    r = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    t = CATransform3DMakeTranslation(0, 0, -CUBE_WIDTH);
    _back = CATransform3DConcat(r, t);
    
    if (_parent == nil) {
        _parent = [CALayer layer];
        _parent.bounds = CGRectMake(0, 0, CUBE_WIDTH, CUBE_HEIGHT);
        _parent.position = CGPointMake(CUBE_WIDTH / 2, CUBE_HEIGHT / 2);
        
        [self initParentTransform];
        [self.view.layer addSublayer:_parent];
    }
    if (_layer1 == nil) {
        _layer1 = [CALayer layer];
        _layer1.bounds = CGRectMake(0, 0, CUBE_WIDTH, CUBE_HEIGHT);
        _layer1.position = CGPointMake(CUBE_WIDTH / 2, CUBE_HEIGHT / 2);
        CGColorRef c = [[UIColor redColor] CGColor];
        _layer1.backgroundColor = c;
        _layer1.opacity = 0.8;
        CGColorRelease(c);
        _layer1.transform = _right;
        [_parent addSublayer:_layer1];
    }
    
    if (_layer2 == nil) {
        _layer2 = [CALayer layer];
        _layer2.bounds = CGRectMake(0, 0, CUBE_WIDTH, CUBE_HEIGHT);
        _layer2.position = CGPointMake(CUBE_WIDTH / 2, CUBE_HEIGHT / 2);
        CGColorRef c =[[UIColor greenColor] CGColor];
        _layer2.backgroundColor = c;
        _layer2.opacity = 0.8;
        CGColorRelease(c);
        _layer2.transform = _front;
        [_parent addSublayer:_layer2];
    }

    if (_layer3 == nil) {
        _layer3 = [CALayer layer];
        _layer3.bounds = CGRectMake(0, 0, CUBE_WIDTH, CUBE_HEIGHT);
        _layer3.position = CGPointMake(CUBE_WIDTH / 2, CUBE_HEIGHT / 2);
        CGColorRef c =[[UIColor blueColor] CGColor];
        _layer3.backgroundColor = c;
        _layer3.opacity = 0.8;
        CGColorRelease(c);
        _layer3.transform = _left;
        [_parent addSublayer:_layer3];
    }
    
    if (_layer4 == nil) {
        _layer4 = [CALayer layer];
        _layer4.bounds = CGRectMake(0, 0, CUBE_WIDTH, CUBE_HEIGHT);
        _layer4.position = CGPointMake(CUBE_WIDTH / 2, CUBE_HEIGHT / 2);
        CGColorRef c =[[UIColor yellowColor] CGColor];
        _layer4.backgroundColor = c;
        _layer4.opacity = 0.8;
        CGColorRelease(c);
        _layer4.transform = _back;
        [_parent addSublayer:_layer4];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action1:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1];
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, -CUBE_WIDTH / 2);
    _parent.sublayerTransform = CATransform3DRotate(_parent.sublayerTransform, M_PI * 0.5, 0, 1, 0);
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, CUBE_WIDTH / 2);
    [CATransaction commit];
    _frontRad += M_PI * 0.5;
}

- (IBAction)action2:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1];
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, -CUBE_WIDTH / 2);
    _parent.sublayerTransform = CATransform3DRotate(_parent.sublayerTransform, -M_PI * 0.5, 0, 1, 0);
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, CUBE_WIDTH / 2);
    [CATransaction commit];
    _frontRad -= M_PI * 0.5;
}

- (void)initParentTransform {
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 800;
    _parent.sublayerTransform = perspective;
}

- (void)rotateTo:(CGFloat)rad withAnimation:(BOOL)animation {
    [CATransaction setDisableActions:!animation];
    [self initParentTransform];
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, -CUBE_WIDTH / 2);
    _parent.sublayerTransform = CATransform3DRotate(_parent.sublayerTransform, rad, 0, 1, 0);
    _parent.sublayerTransform = CATransform3DTranslate(_parent.sublayerTransform, 0, 0, CUBE_WIDTH / 2);
}

#pragma mark touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _touch = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGFloat dx = _touch.x - point.x;
    CGFloat rad = -dx / self.view.frame.size.width * M_PI * 0.5 + _frontRad;
    [self rotateTo:rad withAnimation:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGFloat ratio = - (_touch.x - point.x) / self.view.frame.size.width;
    if (ratio < -0.5) {
        [self rotateTo:_frontRad - M_PI * 0.5 withAnimation:YES];
        _frontRad = _frontRad - M_PI * 0.5;
    } else if (0.5 < ratio) {
        [self rotateTo:_frontRad + M_PI * 0.5 withAnimation:YES];
        _frontRad = _frontRad + M_PI * 0.5;
    } else {
        [self rotateTo:_frontRad withAnimation:YES];
        _frontRad = _frontRad;
    }
}

@end
