//
//  MuKeMessage.m
//  MuKeMessage
//
//  Created by 谭 昱国 on 13-10-9.
//  Copyright (c) 2013年 AHITS. All rights reserved.
//

#import "Message.h"
#import <Accelerate/Accelerate.h>
@interface Message()
{
    UIImageView *backView;
    
    BOOL isWaiting; //是否正在显示等待网络操作视图
    
    UIImageView *circle; //等待网络操作时显示一个不停旋转的圆
    
    NSTimer *_timer;
    
    NSTimer *_timerForTimeout;
    
 
    
    void (^_block)(void);
}
@end

@implementation Message

//使用单例模式
+ (Message *)sharedMessage{
    static Message *sharedMessageInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedMessageInstance = [[self alloc] init];
    });
    return sharedMessageInstance;
}



//帧动画
-(void)createKeyAnimationView{
    NSArray *array = @[@"loading_1",@"loading_2",@"loading_3",@"loading_4",@"loading_5",@"loading_6",@"loading_7"];
    
    NSMutableArray *imageArray = [NSMutableArray new];
    for(int i = 0;i<array.count;i++){
        NSString *imageName=[NSString stringWithFormat:@"loading_%d",i+1];
        UIImage *image=[UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    
    // 设置图片的序列帧 图片数组
    circle.animationImages = imageArray;
    //动画重复次数
    circle.animationRepeatCount = 0;
    //动画执行时间,多长时间执行完动画
    circle.animationDuration = 1.0;
    //开始动画
    [circle startAnimating];
}

//以12个点旋转的方式
-(void)createAnimationView{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  backView.center;
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [backView.layer addSublayer:replicatorLayer];
    
    
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 10, 10);
    dot.position        = CGPointMake(50, 20);
    dot.backgroundColor = colorWithRGBString(@"#ff992b").CGColor;
    dot.cornerRadius    = 5;
    dot.masksToBounds   = YES;
    
    [replicatorLayer addSublayer:dot];
    
    
    CGFloat count                     = 10.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0.1;
    animation.repeatCount = MAXFLOAT;
    [dot addAnimation:animation forKey:nil];
    
    
    replicatorLayer.instanceDelay = 1.0/ count;
    
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

//截取屏幕
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

//高斯模糊
-(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
//    if (blur < 0.f || blur > 1.f) {
//        blur = 0.5f;
//    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}




- (void)showWaitingWithStopOperation:(void (^)(void))block{
    
    
    _block = block;
}

- (void)hideWaiting{
    
    
    if (isWaiting){
        [_timer invalidate];
        _timer = nil;
        
        [_timerForTimeout invalidate];
        _timerForTimeout = nil;
        
        [backView removeFromSuperview];
        
        isWaiting = NO;
    }
}

//在屏幕下方弹出一条提示，一段时间后自动消失。提示内容为message
- (void)showFlashMessage:(NSString *)message{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGSize size = CGSizeMake(window.frame.size.width-40, 34);
    CGSize textRealSize = CGSizeMake(0, 0);
    if ([message respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textRealSize = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
    }
    textRealSize.width += 20;
    
    UILabel *flashMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(window.frame.size.width/2 - textRealSize.width / 2, window.bounds.size.height - 80, textRealSize.width, 34)];
    flashMessageLabel.numberOfLines = 0;
    flashMessageLabel.backgroundColor = [UIColor clearColor];
    flashMessageLabel.textAlignment = NSTextAlignmentCenter;
    flashMessageLabel.textColor = [UIColor whiteColor];
    flashMessageLabel.font = [UIFont systemFontOfSize:14];
    flashMessageLabel.text = message;
    
    flashMessageLabel.layer.backgroundColor = [UIColor blackColor].CGColor;
    flashMessageLabel.layer.cornerRadius = 5;
    flashMessageLabel.layer.borderColor = [UIColor blackColor].CGColor;
    flashMessageLabel.layer.borderWidth = 1;
    flashMessageLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    flashMessageLabel.layer.shadowOffset = CGSizeMake(0, 0);
    flashMessageLabel.layer.shadowRadius = 1;
    
    [window addSubview:flashMessageLabel];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [flashMessageLabel removeFromSuperview];
    });
}

//在屏幕下方弹出一条提示消息，一段时间后自动消失。
- (void)showImageMessage:(NSString *)message isCorrect:(BOOL)isCorrect{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGSize size = CGSizeMake(window.frame.size.width-40, kSize(48));
    CGSize textRealSize;
    if ([message respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textRealSize = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:kFont(48)] forKey:NSFontAttributeName] context:nil].size;
    }
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (window.frame.size.width-kSize(108+108)-textRealSize.width)/2, (window.bounds.size.height-kSize(72+120+24+48+72))/2, kSize(108*2)+textRealSize.width, kSize(72+120+24+48+72))];
    view.alpha = 0.8;
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = kSize(18);
    view.layer.masksToBounds = YES;
    [window addSubview:view];
    
    CGFloat viewWidth = view.bounds.size.width;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((viewWidth-kSize(120))/2, kSize(72), kSize(120), kSize(120))];
    if (isCorrect) {
        imageView.image = [UIImage imageNamed:@"icon8_5"];
    }else{
        imageView.image = [UIImage imageNamed:@"icon8_6"];
    }
    [view addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kSize(108), CGRectGetMaxY(imageView.frame)+kSize(24), textRealSize.width, kSize(48))];
    label.font = [UIFont systemFontOfSize:kFont(48)];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [view removeFromSuperview];
    });
}

- (void)showActivityIndicator:(NSString *)message {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0.5];
    [window addSubview:bgView];
    
    
    
    CGSize size = CGSizeMake(window.frame.size.width-40, kSize(48));
    CGSize textRealSize = CGSizeMake(0, 0);
    if ([message respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textRealSize = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:kFont(48)] forKey:NSFontAttributeName] context:nil].size;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (window.frame.size.width-kSize(108+108)-textRealSize.width)/2, (window.bounds.size.height-kSize(72+120+24+48+72))/2, kSize(108*2)+textRealSize.width, kSize(72+120+24+48+72))];
    view.alpha = 0.8;
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = kSize(18);
    view.layer.masksToBounds = YES;
    [bgView addSubview:view];
    
    CGFloat viewWidth = view.bounds.size.width;
    
    indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame=CGRectMake((viewWidth-kSize(120))/2, kSize(72), kSize(120), kSize(120));
    //默认是YES,不可见
    indicatorView.hidden=NO;
    //设置动画停止时是否隐藏，默认是YES
    indicatorView.hidesWhenStopped=NO;
    [indicatorView startAnimating];
    [view addSubview:indicatorView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kSize(108), CGRectGetMaxY(indicatorView.frame)+kSize(24), textRealSize.width, kSize(48))];
    label.font = [UIFont systemFontOfSize:kFont(48)];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
}

-(void)hiddenActivityIndicator{
    [indicatorView stopAnimating];
    [indicatorView.superview.superview removeFromSuperview];
}

-(void)hiddenActivityIndicator2{
    [indicatorView stopAnimating];
    [indicatorView.superview removeFromSuperview];
}



- (void)showActivityIndicator2 {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0.5];
    [window addSubview:bgView];
    
    
    indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame=CGRectMake((kSelfWidth-kSize(120))/2, (kSelfHeight-kSize(120))/2, kSize(120), kSize(120));
    //默认是YES,不可见
    indicatorView.hidden=NO;
    //设置动画停止时是否隐藏，默认是YES
    indicatorView.hidesWhenStopped=NO;
    [indicatorView startAnimating];
    [bgView addSubview:indicatorView];
}


- (void)handleTap:(UITapGestureRecognizer *)sender{
    if (_block) {
        _block();
    }
    
    [self hideWaiting];
}

- (void)rotate{
    CGAffineTransform transform = circle.transform;
    transform = CGAffineTransformRotate(transform, M_PI/10);
    circle.transform = transform;
}

- (void)handleTimeout{
    [self hideWaiting];
    
    [self showFlashMessage:@"网络繁忙,请稍后再试"];
}

@end
