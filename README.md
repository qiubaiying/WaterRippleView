
# WaterRippleView

水波纹动画视图

## Overview

![](http://ww2.sinaimg.cn/large/006tNc79gy1fgva2b3bqng30ij0ag12n.gif)

## Setting

![](http://ww1.sinaimg.cn/large/006tNbRwgy1fglz7is7ngj30dc04sjs6.jpg)

## Usage

```objc
// init
self.waterRippleView = [[WaterRippleView alloc] init];
self.waterRippleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
[self.view addSubview:self.waterRippleView];
    
self.waterRippleView.progress = 0.23;
self.waterRippleView.amplitude = 14;
self.waterRippleView.cycle = 2.5;
self.waterRippleView.speed = 5;
self.waterRippleView.moveDirection = YES;
[self.waterRippleView startAnimation];
```

## Note

若在 Cell 中复用 `WaterRippleView` 必须先调用 `stopAnimation`清除原先的动画图层，否则动画图层会叠加。

	[self.waterView stopAnimation];
	[self.waterView startAnimation];
	
## License

This project is under MIT License. See LICENSE file for more information.
