//
//  JJHomeController.m
//  JJFontFit
//
//  Created by JMZiXun on 2018/4/18.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JJHomeController.h"
#import "JJFontFit.h"
#import "JJExampleTableViewController.h"
#define kJJIPHONE_47 375.0

@interface JJHomeController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,assign) CGFloat testWidth;
@property (nonatomic ,assign) CGFloat addSize;
@property (weak, nonatomic) IBOutlet UISwitch *widthSwitch;
@property (nonatomic ,strong) NSArray *iphoneWidths;
@end

@implementation JJHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     使用说明：
     1、 JJFontFit类一般是放在程序入口AppDelegate中调用。（为了看测试效果，所以有部分设置放在JJHomeController类中设置）
     2、 自定义以“UI”，“_UI”开头的继承UILabel或UIButton类默认是不支持文字大小适配的，
     要想支持字体适配，需要手动调用+ (void)addHasPrefixUIWithLabelClass:(NSArray<NSString *>*)labelClass buttonClass:(NSArray<NSString *>*)buttonClass 方法，传了父类，它的子类默认支持。
     3、如果想要某个类都不支持文字适配，可调用+ (void)closeFontFitWithClass:(NSArray<NSString *>*)closeClass方法，注意：调用方法后，它的子类也是不支持文字适配的
      4、支持的样式有两种：（默认样式是第一种）
            1）、根据屏幕全自动适配，只需要在外部调用+ (void)fontFitWithNormalScreenWidth:(CGFloat)width方法来设置以哪个尺寸作为标准（默认的4.7寸手机）。
            2）、在外部根据屏幕来判断，调用+ (void)fontFitWithAddSize:(CGFloat)addSize来设置不同的值来进行适配，当传入的addSize=0时，说明以该手机尺寸作为标准。
       5、该+ (void)jj_testFontFitWithWidth:(CGFloat)width方法,是为了能在同一个设备，看到不同的适配效果，仅仅是在"样式一"下测试用的。
    */
    
    
    //屏幕4.7寸为基准
    [JJFontFit fontFitWithNormalScreenWidth:kJJIPHONE_47];
    self.testWidth = [UIScreen mainScreen].bounds.size.width;
    [self.segmented addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.titles = @[@"4.0",@"4.7",@"5.5"];
    self.iphoneWidths = @[@"320",@"375",@"414"];
    [self setupTitleView];
    // Do any additional setup after loading the view.
}
- (IBAction)textWidthSwitch:(UISwitch *)sender {
    
    [JJFontFit shareFontFit].jj_adjustsFontSizeToFitWidth = sender.on;
}

- (void)change:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        //测试方法
        [JJFontFit jj_testFontFitWithWidth:self.testWidth];
    }else{
        //调用该方法，说明字体采用的是在原来字体上进行添加大小样式进行适配
        [JJFontFit fontFitWithAddSize:self.addSize];
    }
}

- (void)setupTitleView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat leftmargin = 20;
    CGFloat length = (width-leftmargin)/self.titles.count;
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(leftmargin+(i%self.titles.count*length), 180, (length-10), 35)];
        [button setTitle:[NSString stringWithFormat:@"%@机型",self.titles[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        if (width == [self.iphoneWidths[i] floatValue]) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor blueColor]];
            [self setupFontFitWithIndex:i];
        }
        button.tag = i+100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    
    for (int i = 0; i < self.titles.count; i ++) {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    button.selected = YES;
    [button setBackgroundColor:[UIColor blueColor]];
    
    NSInteger index = button.tag-100;
    [self setupFontFitWithIndex:index];
}

- (void)setupFontFitWithIndex:(NSInteger)index{
    
  
    switch (index) {
        case 0://4.0寸手机
        {
            CGFloat iphone40_Width = 320;
            self.testWidth = iphone40_Width;
            //在标准尺寸下文字大小下进行-6
            self.addSize = -6;
        }
            break;
        case 1://4.7寸手机
        {
            CGFloat iphone47_Width = kJJIPHONE_47;
            self.testWidth = iphone47_Width;
            //标准尺寸
            self.addSize = 0;
        }
            break;
        case 2://5.5寸手机
        {
            CGFloat iphone55_Width = 414;
            self.testWidth = iphone55_Width;
            //在标准尺寸下文字大小下进行+6
            self.addSize = 12;
        }
            break;
            
        default:
            break;
    }
    
    [self change:self.segmented];
}
- (IBAction)lookBtnClick:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([JJExampleTableViewController class])];
    viewController.title = @"example";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
