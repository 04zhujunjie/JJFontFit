//
//  AppDelegate.m
//  JJFontFit
//
//  Created by JMZiXun on 2018/4/18.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "AppDelegate.h"
#import "JJFontFit.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupFontFit];
//    [self setupFontFitWithCustom];
//    [self setupFontFitWithNormal];
    return YES;
}

- (void)setupFontFit{
    
    //设置支持自定义以“UI”，“_UI”开头的继承UILabel或UIButton类
    [JJFontFit addHasPrefixUIWithLabelClass:@[@"UIJJLabel",@"_UIJJLabel"] buttonClass:@[@"UIJJButton"]];
    //关闭适配的类，它的子类也会被关闭
    [JJFontFit closeFontFitWithClass:@[@"JJTextField_1"]];
}

//标准样式
- (void)setupFontFitWithNormal{
    //以4.7寸手机屏幕为基准
    [JJFontFit fontFitWithNormalScreenWidth:375.0];
    //设置支持自定义以“UI”，“_UI”开头的继承UILabel或UIButton类，它的子类也会支持适配
    [JJFontFit addHasPrefixUIWithLabelClass:@[@"UIJJLabel",@"_UIJJLabel"] buttonClass:@[@"UIJJButton"]];
    //关闭适配的类，它的子类也会被关闭
    [JJFontFit closeFontFitWithClass:@[@"JJTextField_1"]];
}

//自定义样式
- (void)setupFontFitWithCustom{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (width == 320) {//4.0寸手机
        //在原来字体的大小上-2
        [JJFontFit fontFitWithAddSize:-2];
    }else if (width == 375){//4.7寸手机
        //字体大小不变
        [JJFontFit fontFitWithAddSize:0];
    }else if(width == 414){//5.5寸手机
         //在原来字体的大小上+2
        [JJFontFit fontFitWithAddSize:2];
    }else{
        //字体大小不变
        [JJFontFit fontFitWithAddSize:0];
    }
    
    //设置支持自定义以“UI”，“_UI”开头的继承UILabel或UIButton类，它的子类也会支持适配
    [JJFontFit addHasPrefixUIWithLabelClass:@[@"UIJJLabel",@"_UIJJLabel"] buttonClass:@[@"UIJJButton"]];
    //关闭适配的类，它的子类也会被关闭
    [JJFontFit closeFontFitWithClass:@[@"JJTextField_1"]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
