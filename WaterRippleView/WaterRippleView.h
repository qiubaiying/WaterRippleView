//
//  WaterRippleView.h
//  WaterWave
//
//  Created by 邱柏荧 on 2017/5/24.
//  Copyright © 2017年 BY. All rights reserved.
//  水波纹进度条

#import <UIKit/UIKit.h>

@interface WaterRippleView : UIView

/* y = Asin(ωx+φ)+h */

@property (nonatomic, assign) CGFloat amplitude;// 振幅
@property (nonatomic, assign) CGFloat cycle;// 周期
@property (nonatomic, assign) CGFloat speed;//水波移动速度
@property (nonatomic, assign) BOOL moveDirection;// 移动方向 默认 <-

/** 进度 默认0.5 */
@property (nonatomic, assign) CGFloat progress;

/** 预警值 0 ~ 1 */
@property (nonatomic, assign) CGFloat warningValue;


- (void)startAnimation;
- (void)stopAnimation;

@end
