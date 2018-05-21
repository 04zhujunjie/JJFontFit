# JJFontFit 
![image](https://github.com/04zhujunjie/JJFontFit/blob/master/Screenshot/JJFontFit.gif) 
## 支持pod导入
pod 'JJFontFit', '~> 1.0.0'     
## 特性：  
1、全自动化，支持自定义字体，不需要手动一个一个适配。     
2、有两种适配样式: 1）、标准样式：根据屏幕比例自动适配。2）、自定义样式 ：用户可以根据屏幕来设置每个屏幕统一字体。        
3、支持UILabel，UIButton，UITextField,UITextView类以及自定义的继承类。    
4、支持某些类和某个对象不适配。     
5、关闭某个对象适配，支持手动代码和storyboard两种设置。      
6、支持不分屏幕尺寸，统一修改字体大小。     

## 使用说明

将JJFontFit文件夹拖到项目中或者通过pod方式导入到项目中，就默认已经开启文字适配（默认使用的标准样式，默认标准屏幕尺寸4.7），
如需进行其他设置，需要导入JJFontFit.h头文件。

1、使用标准样式，调用以下方法，设置标准屏幕的宽（也就是字体不变的屏幕宽）   
```
+ (void)fontFitWithNormalScreenWidth:(CGFloat)width
```
2、使用自定义样式，用户根据屏幕大小，调用以下方法，设置不同的addSize值，addSize=0时，该屏幕为标准屏幕 
```
+ (void)fontFitWithAddSize:(CGFloat)addSize;
```
3、自定义的以“UI”、“_UI”开头的继承UILabel或UIButton类，默认是不支持字体适配的，要想支持字体适配需要手动调用以下方法，
如果你传入的是父类名，它的子类也会支持文字适配
```
+ (void)addHasPrefixUIWithLabelClass:(NSArray<NSString *>*)labelClass buttonClass:(NSArray<NSString *>*)buttonClass;
```
4、关闭整个适配的类（包括它的子类），只需要调用以下方法，传入类名 
```
+ (void)closeFontFitWithClass:(NSArray<NSString *>*)closeClass;
```
5、用代码关闭某个对象的文字适配，将isNotFontFit设置为YES  
```
self.label.isNotFontFit = YES;
```
6、在storyboard或xib上关闭某个对象文字适配，将Is Not Font Fit设置为On  

![image](https://github.com/04zhujunjie/JJFontFit/blob/master/Screenshot/storyboard_screen.png) 

7、不分屏幕尺寸，统一修改字体大小 ，直接调用以下方法 
```
+ (void)fontFitWithAddSize:(CGFloat)addSize;
```
8、JJFontFit设置，一般是放在程序入口AppDelegate设置，如下：  
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupFontFitWithNormal];
    //[self setupFontFitWithCustom];
    return YES;
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

```

## 其他
QQ交流群：680365301     
