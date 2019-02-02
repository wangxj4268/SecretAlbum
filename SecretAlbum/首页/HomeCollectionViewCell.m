//
//  HomeCollectionViewCell.m
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell()
{
    UIImageView *imageView;
    UILabel *saveLabel;
}
@end
@implementation HomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kSelfWidth-30)/2, (kSelfHeight-64-49-30)/2)];
        [self.contentView addSubview:imageView];
        
        CGFloat saveLabelWidth = stringSize(@"已保存", kFont(42), kSelfWidth).width+5;
        saveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, saveLabelWidth, kSize(42))];
        saveLabel.font = [UIFont systemFontOfSize:kFont(42)];
        saveLabel.textColor = colorWithRGBString(KC1);
        saveLabel.text = @"已保存";
        saveLabel.hidden = YES;
        [imageView addSubview:saveLabel];
    
        UILongPressGestureRecognizer *gesTure = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesTure];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.hidden = YES;
        _selectBtn.frame = CGRectMake(imageView.bounds.size.width-kSize(144), 0, kSize(144), kSize(144));
        [_selectBtn setImage:[UIImage imageNamed:@"car_easy_list_control_checkbox_normal_left"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"car_easy_list_control_checkbox_selected_left"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:_selectBtn];
    }
    return self;
}

-(void)setModel:(HomeCollectionModel *)model{
    _model = model;
    imageView.image = Base64StrToUIImage(model.imageStr);
    
    if([model.saveToLocal boolValue]){
        saveLabel.hidden = NO;
    }else{
        saveLabel.hidden = YES;
    }
    
    if ([model.isShowSelectBtn boolValue]) {
        _selectBtn.hidden = NO;
    }else{
        _selectBtn.hidden = YES;
    }
    
    if ([model.isSelected boolValue]) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
}

-(void)imageClick:(UILongPressGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleLongGestureOnClick:)]) {
        [self.delegate handleLongGestureOnClick:self.tag];
    }
}

-(void)selectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSelectedWithIndex:)]) {
        [self.delegate handleSelectedWithIndex:self.tag];
    }
}

@end
