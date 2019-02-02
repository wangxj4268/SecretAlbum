//
//  Global.h
//  EasyCar
//
//  Created by QQSS on 15/5/26.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#ifndef EasyCar_Global_h
#define EasyCar_Global_h

#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"


//获取屏幕尺寸
CGFloat getScreenWidth();
CGFloat getScreenHeight();


#define ScreenSize [UIScreen mainScreen].bounds.size
#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 5*5)/4
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define DistanceFromTopGuiden(view) (view.frame.origin.y + view.frame.size.height)
#define DistanceFromLeftGuiden(view) (view.frame.origin.x + view.frame.size.width)
#define ViewOrigin(view)   (view.frame.origin)
#define ViewSize(view)  (view.frame.size)



//判断手机号码格式是否正确
BOOL isValidateMobile(NSString *mobile);


//对字符串str进行MD5编码
NSString *md5(NSString *str);

//是否是 正确的银行卡号格式
BOOL checkCardNo(NSString *cardNo);

//是否是 正确的身份证号格式
BOOL CheckIsIdentityCard(NSString *identityCard);

//判断车架号格式是否正确
BOOL isValidateVinOrCarNoOrEngineNo(NSString *str);

//判断是否车架号后count位
BOOL isValidateVIN_lastNumbers(NSString *vin, NSUInteger count);

//判断车牌号是否正确
BOOL isValidCarNumber(NSString *carNumber);

//判断是否整数
BOOL isValidateAllNumbers(NSString *str);

//判断是否非负浮点数
BOOL isNonNegativeFloat(NSString *str);

//判断是否时间戳格式
BOOL isStamp(NSString *str);

BOOL isStamp1(NSString *str);

BOOL isStamp2(NSString *str);

//将时间戳转换成标准时间格式
NSString *stampToDate(NSString *stamp);

//去除浮点数尾部多余的0
NSString *stringDisposeWithDouble(double val);

//给浮点数保留最多指定位数的小数
NSString *newFloatWithMaxNumber(double val, int numberOfPlace);
NSString *newFloatStringWithMaxNumber(NSString *floatString, int numberOfPlace);

//判断val是否非空
BOOL notNull(id val);

//后台上报车辆位置信息时，需要传车牌号。而车牌号首位的省简称是汉字，会变成乱码，所以要改成英文字符上传
NSString *hashMapCarNo(NSString *carno);

//新版日期格式 当年的日期只显示月-日
NSString *newDateStringFromString(NSString *firstDateString);
//新版日期格式  不包含汉字
NSString *newDateWithoutChineseStringFromString(NSString *firstDateString) ;

//yyyy年MM月dd日
NSString *DateStringWithYearMonthDayAndChineseWordFromDate(NSDate *date);
//yyyy-MM-dd
NSString *DateStringWithYearMonthDayWithoutChineseWordFromDate(NSDate *date);
//yyyy年MM月
NSString *DateStringWithYearMonthAndChineseWordFromDate(NSDate *date);
//yyyy-MM
NSString *DateStringWithYearMonthWithoutChineseWordFromDate(NSDate *date);
//MM-DD
NSString *DateStringWithMonthDayWithoutChineseWordFromDate(NSDate *date);

//在程序的临时文件夹中创建一个临时文件，用于在iOS5系统中调试
//Xcode7不支持iOS5设备真机调试

//创建文件
void createFile();

void writeFile(NSString *str);

//去除一个字典中的空值（当需要把一个字典保存到本地时，其中不能有空值）
void filterNullValueInDictionary(NSMutableDictionary *dic);
void filterNullValueInDictionary1(NSMutableDictionary *dic);

//将#ffffff变为可用的RGB
UIColor * colorWithRGBString(NSString *stringToConvert);

//自定义image(传首个字符，生成一张图片)
UIImage * setupNewImage(NSString *firstStr);

//计算字的长宽
CGSize stringSize(NSString *str,CGFloat font,CGFloat maxWidth);

//设置UITextField的提示文字的背景色为#666666
NSAttributedString * createPlaceholderBackgroundColorWithString(NSString *str);

NSAttributedString * createPlaceholderBackgroundColorWithStringAndFont(NSString *str,CGFloat font);

NSString * arrayToJSONString(NSArray *array);

//由颜色生成图片
UIImage * createImageWithColor(UIColor* color,CGFloat height);


/**
 判空赋值处理

 @param ret 需要判空的数据
 @param typeStr 数据的类型：NSArray、NSDictionary、NSString
 @param isNeed 是否需要对空数据初始化：只对NSString类型的数据初始化
 @param str 需要初始化的内容
 @return 返回判空后的数据：还是原来的类型
 */
//id isJudgeNull (id ret , NSString *typeStr ,BOOL isNeed ,NSString* str);


NSArray * judgeNSArrayNull (NSArray *arr);
NSDictionary * judgeNSDictionaryNull (NSDictionary *dic);
NSString * judgeNSStringNull (NSString *string,NSString *defaultString);

UIImage *Base64StrToUIImage (NSString *_encodedImageStr);

#endif
