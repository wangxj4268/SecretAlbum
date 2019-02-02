//
//  VoiceToSoundController.m
//  SecretAlbum
//
//  Created by 王雪剑 on 2018/8/23.
//  Copyright © 2018年 zkml－wxj. All rights reserved.
//

#import "WordToVoiceController.h"
#import "iflyMSC/IFlyMSC.h"

#define textViewPlaceHolder @"请输入您需要播放的文字"
@interface WordToVoiceController ()<IFlySpeechSynthesizerDelegate,UITextViewDelegate>
{
    UITextView *inputTextView;
    BOOL isCanceled;
}
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation WordToVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文字转语音";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithRGBString(KCDefault);
    
    [self createUI];
    [self initIfly];
}

-(void)createUI{
    inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(kSize(48), kStatusBarAndNavigationBarHeight+kSize(48), kSelfWidth-kSize(96), kSelfHeight-kSize(48+144*2+48+24)-kStatusBarAndNavigationBarHeight)];
    inputTextView.delegate = self;
    inputTextView.text = textViewPlaceHolder;
    inputTextView.textColor = colorWithRGBString(KC9);
    [self.view addSubview:inputTextView];
    
    CGFloat btnWidth = (kSelfWidth-kSize(96+48+48))/3;
    CGFloat btnHeight = kSize(144);
    CGFloat jianJuHeight = kSize(24);
    NSArray *btnTitleArray = @[@"开始播放",@"取消播放",@"暂停播放",@"继续播放",@"清空文本"];
    for(int i =0 ;i < btnTitleArray.count ;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%3*(btnWidth+kSize(48))+kSize(48), CGRectGetMaxY(inputTextView.frame)+kSize(24)+i/3*(btnHeight+jianJuHeight), btnWidth, btnHeight);
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:colorWithRGBString(KC7) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        btn.titleLabel.font = [UIFont systemFontOfSize:kFont(48)];
        btn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btn];
    }
}

-(void)initIfly{
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm"
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    //[_iFlySpeechSynthesizer startSpeaking: @"你好，我是科大讯飞的小燕"];
}

#pragma mark ********【代理】********IFlySpeechSynthesizerDelegate的代理
// 合成结束
- (void) onCompleted:(IFlySpeechError *) error {
    NSString *text ;
    if (isCanceled) {
        text = @"播放取消";
    }else if (error.errorCode == 0) {
        text = @"播放结束";
    }else {
        text = [NSString stringWithFormat:@"Error：%d %@",error.errorCode,error.errorDesc];
    }
    [[Message sharedMessage] showFlashMessage:text];
}

// 合成开始
- (void) onSpeakBegin {
    isCanceled = NO;
    [[Message sharedMessage] hiddenActivityIndicator];
}

// 合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    
}

// 合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    
}

#pragma mark ********【操作】********操作按钮
-(void)btnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        [self startPlay];
    }else if (sender.tag == 2){
        [self cancelPlay];
    }else if (sender.tag == 3){
        [self pausePlay];
    }else if(sender.tag == 4){
        [self continuePlay];
    }else if (sender.tag == 5){
        [self clearTextView];
    }
}

// 开始播放
-(void)startPlay{
    [[Message sharedMessage] showActivityIndicator:@"正在缓冲..."];
    [_iFlySpeechSynthesizer startSpeaking:inputTextView.text];
}

// 取消播放
-(void)cancelPlay{
    isCanceled = YES;
    [_iFlySpeechSynthesizer stopSpeaking];
}

// 暂停播放
-(void)pausePlay{
    [_iFlySpeechSynthesizer pauseSpeaking];
}

// 继续播放
-(void)continuePlay{
    [_iFlySpeechSynthesizer resumeSpeaking];
}

// 清空文本
-(void)clearTextView{
    inputTextView.text = textViewPlaceHolder;
    inputTextView.textColor = colorWithRGBString(KC9);
}

#pragma mark ********【代理】********UITextView的代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:textViewPlaceHolder]){
        textView.text = @"";
        textView.textColor = colorWithRGBString(KC7);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        textView.text = textViewPlaceHolder;
        textView.textColor = colorWithRGBString(KC9);
    }
    [textView resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
