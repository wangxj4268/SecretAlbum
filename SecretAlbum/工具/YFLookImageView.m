//
//  YFLookImageView.m
//  NewRefactorEasyCar
//
//  Created by 王雪剑 on 2018/1/11.
//  Copyright © 2018年 张凯翔. All rights reserved.
//

#import "YFLookImageView.h"

@interface YFLookImageView ()<UIScrollViewDelegate>
{
    UILabel *indexLabel;
    NSMutableArray *sourceViewArray;//保存imageView
    NSMutableArray *sourceScrArray;//保存scrollView
    NSInteger currentIndex;//当前滚动的索引,从0开始
    UIScrollView *_scrollView;
}
@end

@implementation YFLookImageView

-(id)initWithImageArray:(NSArray *)itemArray withIndex:(NSInteger)index{
    if (self = [super init]) {
        [self createViewWithImageArray:itemArray withIndex:index];
    }
    return self;
}

#pragma mark ********【界面】********滑动切换图片界面
-(void)createViewWithImageArray:(NSArray *)itemArray withIndex:(NSInteger)index{
    sourceViewArray = [NSMutableArray new];
    sourceScrArray = [NSMutableArray new];
    currentIndex = index;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.userInteractionEnabled = YES;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kSelfWidth*itemArray.count, self.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    for (NSInteger i = 0; i<itemArray.count; i++) {
        UIScrollView *littleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i*kSelfWidth, 0, kSelfWidth, kSelfHeight)];
        littleScrollView.delegate = self;
        littleScrollView.maximumZoomScale = 2;
        littleScrollView.minimumZoomScale = 1;
        [_scrollView addSubview:littleScrollView];
        
        NSDictionary *dic = itemArray[i];
        NSString *str = [dic objectForKey:@"imageBase64"];
        UIImage *image = Base64StrToUIImage(str);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSelfWidth, kSelfHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = image;
        [littleScrollView addSubview:imageView];
        
        [sourceViewArray addObject:imageView];
        [sourceScrArray addObject:littleScrollView];
    }
    
    [_scrollView setContentOffset:CGPointMake(index*kSelfWidth, 0) animated:NO];
    
    
    //模拟导航栏，包含返回按钮
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSelfWidth,kStatusBarAndNavigationBarHeight)];
    headView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:headView];
    
    //模拟导航栏上的返回按钮
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kStatusBarAndNavigationBarHeight, kStatusBarAndNavigationBarHeight)];
    [headView addSubview:leftView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSize(48), kStatusBarHeight+(44-kSize(72))/2, kSize(72), kSize(72))];
    imageView.image = [UIImage imageNamed:@"icon1_3"];
    [leftView addSubview:imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBtnClick:)];
    [leftView addGestureRecognizer:tapGesture];
    
    indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), kStatusBarHeight, kSelfWidth-2*CGRectGetMaxX(leftView.frame), 44)];
    indexLabel.font = [UIFont systemFontOfSize:kFont(48)];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,itemArray.count];
    [headView addSubview:indexLabel];
    
    
    //仿原生系统的弹出效果
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}


-(void)animationStyle{
    // 缩放动画
    CABasicAnimation *a2 = [CABasicAnimation animation];
    a2.keyPath = @"transform.scale";
    a2.toValue = @(0.0);
    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.delegate = self;
    groupAnima.animations = @[a2];
    
    //设置组动画的时间
    groupAnima.duration = 0.4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = 1;
    [self.layer addAnimation:groupAnima forKey:nil];
}

-(void)animationDidStart:(CAAnimation *)anim{
    SNLog(@"--开始动画--");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    SNLog(@"--结束动画--");
    [self.superview removeFromSuperview];
}

#pragma mark ********【代理】********UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        currentIndex = scrollView.contentOffset.x/kSelfWidth;
        indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,sourceViewArray.count];
    }
}

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return sourceViewArray[currentIndex];
}

#pragma mark ********【操作】********返回
-(void)leftBtnClick:(UITapGestureRecognizer *)sender{
    [self animationStyle];
}

#pragma mark ********【操作】********单击
- (void)handleCancel:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        UIScrollView *scr = (UIScrollView *)sourceScrArray[currentIndex];
        scr.zoomScale = 1;
    }];
}

- (void)show{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    backView.backgroundColor = [UIColor clearColor];
    [window addSubview:backView];
    
    UIView *view = [[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [backView addSubview:view];
    
    self.center = backView.center;
    [backView addSubview:self];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancel:)];
    [self addGestureRecognizer:tapGR];
}

@end

