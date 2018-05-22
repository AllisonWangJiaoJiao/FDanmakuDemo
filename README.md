# FDanmakuDemo
FDanmakuDemo
使用用法
##### 第一步:
为新的弹幕类型新建一个数据模型 例如:FDanmakuModel. 这个类必须继实现FDanmakuModelProtocol协议.

```
@interface FDanmakuModel : NSObject <FDanmakuModelProtocol>

@property (nonatomic,assign)NSTimeInterval beginTime;
@property (nonatomic,assign)NSTimeInterval liveTime;
@property (nonatomic,copy)NSString *content;

@end
```

这样就创建新的弹幕类型的数据模型类, 我们可以在这个类里面添加新的弹幕属性例如:content等待。

##### 第二步:

为新的弹幕类型创建建一个数据展示视图，这里我用一个UILabel,当然你也可以自定义视图。

```
- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model {
    
    UILabel *label = [UILabel new];
    label.text = model.content;
    [label sizeToFit];
    return label;
}
```
##### 第三步：

模拟当前时间和数据源(实际上这些是接口中获得的，这里模拟数据)

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
    model1.beginTime = 3;
    model1.liveTime = 5;
    model1.content = @"哈哈哈~😊🙂😎~~~";
    
    FDanmakuModel *model2 = [[FDanmakuModel alloc]init];
    model2.beginTime = 3.2;
    model2.liveTime = 8;
    model2.content = @"23322333";
    
    [self.danmakuView.modelsArr addObject:model1];
    [self.danmakuView.modelsArr addObject:model2]; 
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1 ;
    return time;
}

```

##### 第四步：

效果展示

![MacDown logo](http://img.hb.aicdn.com/2d465821c08f2ac5e7b0cb8ae0e1d6f429cd1e2526c15-cL6YVm_fw658)


