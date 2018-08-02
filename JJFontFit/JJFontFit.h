//
//  JJFontFit.h
//  JJFontFit
//
//  Created by JMZiXun on 2018/4/16.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface JJFontFit : NSObject

+ (instancetype)shareFontFit;

/**
文本自适应宽度，默认值NO，只适用UILabel和UIButton字体
适配UILable或者UIButton字体时，如果字体过大，可能会导致文字显示不全，这时你需要将jj_adjustsFontSizeToFitWidth设置为YES。
  作用：1、单行文字时，会自动设置UILabel的adjustsFontSizeToFitWidth属性为YES，使得文字全部显示出来。
       2、多行文字时，不做适配，保留原来文字大小。
 */
@property (nonatomic ,assign) BOOL jj_adjustsFontSizeToFitWidth;
/**
 仅用于在“标准样式”下测试

 @param width 要测试的屏幕尺寸
 */
+ (void)jj_testFontFitWithWidth:(CGFloat)width;


/**
 设置以哪个屏幕尺寸宽作为适配标准，默认是4.7寸屏幕宽， 一般在AppDelegate调用
 内部自动根据根据其他屏幕来适配
 @param width 屏幕宽
 */
+ (void)fontFitWithNormalScreenWidth:(CGFloat)width;
/**
 “自定义样式”时要调用该方法，说明你要在原来字体上追加字体大小来进行适配。一般在AppDelegate调用
 一般在外部根据屏幕尺寸传入不同的addSize来适配，传入的addSize=0时，
 说明那个屏幕尺寸就作为适配标准
 @param addSize 追加大小
 */
+ (void)fontFitWithAddSize:(CGFloat)addSize;
/**
 字体大小转换
 
 @param size 字体大小
 @return 转换后的大小
 */
+ (CGFloat)fontFitWithSize:(CGFloat)size;
/**
系统自带的转换后的字体

 @param size 字体大小
 @return 转换后的字体
 */
+ (UIFont *)fontFitWithSystemFontOfSize:(CGFloat)size;

/**
 系统自带加粗的转换后的字体

 @param size 字体大小
 @return 转换后的字体
 */
+ (UIFont *)fontFitWithBoldSystemFontOfSize:(CGFloat)size;

/**
 字体转换

 @param font 要转换的字体
 @return 转换后的字体
 */
+ (UIFont *)fontFitWithFont:(UIFont *)font;

/**
  自定义的以“UI”、“_UI”开头的继承UILabel或UIButton类，默认是不支持字体适配的，
  要想支持字体适配，可以在AppDelegate手动调用，如UIJJLabel继承UILabel，UIJJButton继承UIButton
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 // Override point for customization after application launch.
 [JJFontFit addHasPrefixUIWithLabelClass:@[NSStringFromClass([UIJJLabel class])] buttonClass:@[NSStringFromClass([UIJJButton class])]];
 return YES;
 }

 @param labelClass 自定义以“UI”、“_UI”开头的继承UILabel类名字符串数组
 @param buttonClass 自定义以“UI”、“_UI”开头的继承UIButton类名字符串数组
 */
+ (void)addHasPrefixUIWithLabelClass:(NSArray<NSString *>*)labelClass buttonClass:(NSArray<NSString *>*)buttonClass;

/**
 关闭适配的类（包括自定义的和原生的）

 @param closeClass 类名
 */
+ (void)closeFontFitWithClass:(NSArray<NSString *>*)closeClass;

@end

@interface UILabel (JJFontFit)
/*
 默认是NO，表示允许文字字体根据屏幕适配大小，设置为YES时，禁止文字字体适配
 */
@property (nonatomic ,assign) IBInspectable BOOL isNotFontFit;

@end

@interface UIButton (JJFontFit)
/*
 默认是NO，表示允许文字字体根据屏幕适配大小，设置为YES时，禁止文字字体适配
 */
@property (nonatomic ,assign) IBInspectable BOOL isNotFontFit;

@end

@interface UITextField (JJFontFit)
/*
 默认是NO，表示允许文字字体根据屏幕适配大小，设置为YES时，禁止文字字体适配
 */
@property (nonatomic ,assign) IBInspectable BOOL isNotFontFit;

@end

@interface UITextView (JJFontFit)
/*
 默认是NO，表示允许文字字体根据屏幕适配大小，设置为YES时，禁止文字字体适配
 */
@property (nonatomic ,assign) IBInspectable BOOL isNotFontFit;

@end
