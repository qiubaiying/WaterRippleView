//
//  WaterRippleView.m
//  WaterWave
//
//  Created by 邱柏荧 on 2017/5/24.
//  Copyright © 2017年 BY. All rights reserved.
//

#import "WaterRippleView.h"

#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define GLColorGreen UIColorFromRGB(0x4eb940)
#define GLColorRed UIColorFromRGB(0xf84d4d)

@interface WaterRippleView()


/** 绘制层 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayerT;

/** 重绘定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/** X 轴方向的平移的距离 */
@property (nonatomic, assign) CGFloat translateX;


/** 水柱的高度 */
@property (nonatomic, assign) CGFloat progressHeight;

@property (nonatomic, assign) CGFloat phase;// 初相位

@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *defaultColorT;
@property (nonatomic, strong) UIColor *waringColor;
@property (nonatomic, strong) UIColor *waringColorT;
@end


@implementation WaterRippleView
@synthesize amplitude, cycle, phase, progressHeight;


- (void)startAnimation {
    [self commitInit];
    [self startDisplayLink];
}


- (void)stopAnimation {
    [self stopDisplayLink];
}

// 初始化数据
- (void)commitInit {
    
    // 设置sin函数参数
    
    amplitude = amplitude > 0.1 ? amplitude : 2;
    cycle =  cycle > 0.1 ? cycle * M_PI / self.frame.size.width : 3 * M_PI / self.frame.size.width;
    phase = M_PI / self.frame.size.width;
    
    // 进度为0 时隐藏动画
    if (!_progress) {
        _progress = CGFLOAT_MIN;
        amplitude = CGFLOAT_MIN;
    }
    
    if (!_warningValue) {
        _warningValue = 0.25;
    }
    
    if (!_speed) {
        _speed = 2;
    }
    
    // 水波高度
    progressHeight = self.frame.size.height * self.progress;
    
    // 移动距离
    self.translateX = 0.0f;
    

    // Color
    _defaultColor = GLColorGreen;
    _defaultColorT = UIColorFromRGB(0xcaeac5);
    _waringColor = GLColorRed;
    _waringColorT = UIColorFromRGB(0xfdc9c9);
    [self addShapeLayer];
}

- (void)addShapeLayer {
    
    // 波纹1
    self.shapeLayer = [CAShapeLayer layer];
    
    // 绘制的路径
    self.shapeLayer.path = [self createSinPath];
    
    // 填充的颜色
    self.shapeLayer.fillColor = self.progress <= self.warningValue ? _waringColor.CGColor : _defaultColor.CGColor;
    
//    // 路径线条的颜色
//    self.shapeLayer.lineWidth = 0.1;
//    // 路径线条的颜色
//    self.shapeLayer.strokeColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] CGColor];
    
    
    
    
    // 波纹2
    
    self.shapeLayerT = [CAShapeLayer layer];

    self.shapeLayerT.path = [self createSinPathT];

    self.shapeLayerT.fillColor = self.progress <= self.warningValue ? _waringColorT.CGColor : _defaultColorT.CGColor;
    
    [self.layer addSublayer:self.shapeLayerT];
    [self.layer addSublayer:self.shapeLayer];
    
    
    
}



- (CGPathRef )createSinPath {
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    progressHeight = (1 - self.progress) * self.frame.size.height;
    
    CGFloat y = 0.0f;
    CGFloat endX = 0;
    for (float x = 0; x <= self.frame.size.width ; x++)
    {
        endX = x;
        // y = Asin(ωx+φ)+h
        y=  amplitude * sin( cycle * x + phase * _translateX) + progressHeight;
        
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    
    CGFloat endY = CGRectGetHeight(self.bounds);
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
//    return  wavePath;
    
    
    return wavePath.CGPath;
}

- (CGPathRef )createSinPathT {
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    progressHeight = (1 - self.progress) * self.frame.size.height;
    
    CGFloat y = 0.0f;
    CGFloat endX = 0;
    for (float x = 0; x <= self.frame.size.width ; x++)
    {
        endX = x;
        
        y =  amplitude * sin( cycle * x + phase * _translateX + M_PI) + progressHeight;
        
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    
    CGFloat endY = CGRectGetHeight(self.bounds);
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    //    return  wavePath;
    
    
    return wavePath.CGPath;
}


- (void)startDisplayLink {
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)stopDisplayLink {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.shapeLayer  removeFromSuperlayer];
    [self.shapeLayerT removeFromSuperlayer];
    
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    
    // 根据改变移动距离（产生动画的源动力）
    if (_moveDirection == NO) {
        self.translateX += self.speed;
    } else {
        self.translateX -= self.speed;
    }
    

    self.shapeLayer.fillColor = self.progress <= self.warningValue ? _waringColor.CGColor : _defaultColor.CGColor;
    self.shapeLayerT.fillColor = self.progress <= self.warningValue ? _waringColorT.CGColor : _defaultColorT.CGColor;
    
    self.shapeLayer.path  = [self createSinPath];
    self.shapeLayerT.path = [self createSinPathT];
    
    
}


-(void)dealloc {
//    NSLog(@"水波纹视图被移除");
    CGPathRelease(self.shapeLayer.path);
    CGPathRelease(self.shapeLayerT.path);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
