//
//  HomeCollectionModel.m
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "HomeCollectionModel.h"

@implementation HomeCollectionModel

-(void)setIsSelected:(NSString *)isSelected{
    if (notNull(isSelected)) {
        _isSelected = isSelected;
    }else{
        _isSelected = @"";
    }
}

-(void)setSaveToLocal:(NSString *)saveToLocal{
    if (notNull(saveToLocal)) {
        _saveToLocal = saveToLocal;
    }else{
        _saveToLocal = @"";
    }
}

-(void)setIsShowSelectBtn:(NSString *)isShowSelectBtn{
    if (notNull(isShowSelectBtn)) {
        _isShowSelectBtn = isShowSelectBtn;
    }else{
        _isShowSelectBtn = @"";
    }
}
@end
