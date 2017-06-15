//
//  ViewController.m
//  WaterRippleView_demo
//
//  Created by 邱柏荧 on 2017/6/15.
//  Copyright © 2017年 BY Qiu. All rights reserved.
//

#import "ViewController.h"
#import "WaterRippleView.h"

@interface ViewController ()

@property (strong, nonatomic) WaterRippleView *waterRippleView;

@property (weak, nonatomic) IBOutlet WaterRippleView *waterRippleViewBySB;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // init创建
    self.waterRippleView = [[WaterRippleView alloc] init];
    self.waterRippleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    [self.view addSubview:self.waterRippleView];
    
    self.waterRippleView.progress = 0.23;
    self.waterRippleView.amplitude = 14;
    self.waterRippleView.cycle = 2.5;
    self.waterRippleView.speed = 5;
    self.waterRippleView.moveDirection = YES;
    [self.waterRippleView startAnimation];
    
    
    // 通过StoryBoard创建
    self.waterRippleViewBySB.progress = 0.5;
    self.waterRippleViewBySB.amplitude = 10;
    self.waterRippleViewBySB.cycle = 2;
    self.waterRippleViewBySB.speed = 4;
    [self.waterRippleViewBySB startAnimation];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
