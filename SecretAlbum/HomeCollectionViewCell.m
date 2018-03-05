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
        saveLabel.textColor = colorWithRGBString(@"ff992b");
        saveLabel.text = @"已保存";
        saveLabel.hidden = YES;
        [imageView addSubview:saveLabel];
        

        
        UILongPressGestureRecognizer *gesTure = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesTure];
    }
    return self;
}

-(void)setModel:(HomeCollectionModel *)model{
    _model = model;
    imageView.image = Base64StrToUIImage(model.imageStr);
    
    if([model.saveToLocal boolValue]){
        saveLabel.hidden = NO;
    }
}

-(void)imageClick:(UILongPressGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleLongGestureOnClick:)]) {
        [self.delegate handleLongGestureOnClick:self.tag];
    }
}


@end
