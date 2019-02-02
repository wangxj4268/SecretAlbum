//
//  VoiceMainViewController.m
//  SecretAlbum
//
//  Created by 王雪剑 on 2018/8/23.
//  Copyright © 2018年 zkml－wxj. All rights reserved.
//

#import "VoiceMainViewController.h"
#import "WordToVoiceController.h"
#import "VoiceToWordController.h"

@interface VoiceMainViewController ()

@end

@implementation VoiceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"语音";
    self.view.backgroundColor = colorWithRGBString(KCDefault);
    [self createView];
}

-(void)createView{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 100, 100, 40);
    btn1.backgroundColor = [UIColor purpleColor];
    [btn1 setTitle:@"文字转语音" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(wordToVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame)+40, 100, 100, 40);
    btn2.backgroundColor = [UIColor purpleColor];
    [btn2 setTitle:@"语音转文字" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(VoiceToWordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

#pragma mark ********【操作】********语音转文字
-(void)VoiceToWordClick:(UIButton *)sender{
    VoiceToWordController *vc = [[VoiceToWordController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark ********【操作】********文字转语音
-(void)wordToVoiceClick:(UIButton *)sender{
    WordToVoiceController *vc = [[WordToVoiceController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
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
