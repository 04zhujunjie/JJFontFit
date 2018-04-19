//
//  JJFontFit.m
//  JJFontFit
//
//  Created by JMZiXun on 2018/4/16.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JJFontFit.h"
#import <objc/runtime.h>

#define JJ_SCREEN_Width [UIScreen mainScreen].bounds.size.width

#define JJ_LOAD(block) \
+(void)load{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,block);\
}

typedef NS_ENUM(NSInteger,JJFontFitType){
    JJFontFitTypeNormal = 0,
    JJFontFitTypeCustom = 1,
};

@interface JJFontFit()


@property (nonatomic ,strong) NSArray<NSString *>* jj_labelClass;
@property (nonatomic ,strong) NSArray<NSString *>* jj_buttonClass;
@property (nonatomic ,assign) CGFloat jj_rate;
@property (nonatomic ,strong) NSArray<NSString *>*jj_closeClass;
@property (nonatomic ,assign) JJFontFitType jj_fontFitType;
@property (nonatomic ,assign) CGFloat jj_addSize;
@property (nonatomic ,assign) CGFloat jj_normalScreenWidth;

@end

@implementation JJFontFit

+ (instancetype)shareFontFit{
    
    static dispatch_once_t onceToken;
    static JJFontFit *fontFit = nil;
    dispatch_once(&onceToken, ^{
        fontFit = [[JJFontFit alloc] init];
        fontFit.jj_normalScreenWidth = 375.0;
        fontFit.jj_rate = JJ_SCREEN_Width/fontFit.jj_normalScreenWidth;
        fontFit.jj_addSize = 0;
    });
    return fontFit;
}


/**
 测试用的
 
 @param width 要测试的屏幕尺寸
 */
+ (void)jj_testFontFitWithWidth:(CGFloat)width{
    [JJFontFit shareFontFit].jj_rate = width/[JJFontFit shareFontFit].jj_normalScreenWidth;
    [JJFontFit shareFontFit].jj_fontFitType = JJFontFitTypeNormal;
}

+ (void)fontFitWithNormalScreenWidth:(CGFloat)width{
    [JJFontFit shareFontFit].jj_normalScreenWidth = width;
    [JJFontFit shareFontFit].jj_rate = JJ_SCREEN_Width/width;
    [JJFontFit shareFontFit].jj_fontFitType = JJFontFitTypeNormal;
}

+ (void)fontFitWithAddSize:(CGFloat)addSize{
    [JJFontFit shareFontFit].jj_addSize = addSize;
    [JJFontFit shareFontFit].jj_fontFitType = JJFontFitTypeCustom;
}

+ (CGFloat)fontFitWithSize:(CGFloat)size{
    return size*[JJFontFit shareFontFit].jj_rate;
}

+ (void)jj_updateFontWithView:(UIView *)view{
    
    switch ([JJFontFit shareFontFit].jj_fontFitType) {
        case JJFontFitTypeNormal:
        {
            UIFont *font = [view valueForKey:@"font"];
            [view setValue:[UIFont fontWithDescriptor:font.fontDescriptor size:font.pointSize*[JJFontFit shareFontFit].jj_rate] forKey:@"font"];
        }
            break;
        case JJFontFitTypeCustom:
        {
            if (![JJFontFit shareFontFit].jj_addSize) {
                return;
            }
            UIFont *font = [view valueForKey:@"font"];
             [view setValue:[UIFont fontWithDescriptor:font.fontDescriptor size:font.pointSize+[JJFontFit shareFontFit].jj_addSize] forKey:@"font"];
        }
            break;
            
        default:
            break;
    }
}

+ (UIFont *)fontFitWithSystemFontOfSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size*[JJFontFit shareFontFit].jj_rate];
}
+ (UIFont *)fontFitWithBoldSystemFontOfSize:(CGFloat)size{
    return [UIFont boldSystemFontOfSize:size*[JJFontFit shareFontFit].jj_rate];
}
+ (UIFont *)fontFitWithFont:(UIFont *)font{
    CGFloat size = font.pointSize;
    return [UIFont fontWithDescriptor:font.fontDescriptor size:size];
}

+ (void)addHasPrefixUIWithLabelClass:(NSArray<NSString *>*)labelClass buttonClass:(NSArray<NSString *>*)buttonClass{
    [JJFontFit shareFontFit].jj_labelClass = labelClass;
    [JJFontFit shareFontFit].jj_buttonClass = buttonClass;
}
+ (void)closeFontFitWithClass:(NSArray<NSString *>*)closeClass{
    [JJFontFit shareFontFit].jj_closeClass = closeClass;
}

@end

@interface UIView (JJFontFit)

//正在适配中
@property (nonatomic ,assign) BOOL jj_isFontFiting;
//视图将添加到父视图中
@property (nonatomic ,assign) BOOL jj_isMoveToSuperview;
//存储旧的font
@property (nonatomic ,strong) UIFont *jj_originalFont;
//是否可以适配
@property (nonatomic ,assign) BOOL jj_isFontFit;
@end

@implementation UIView (JJFontFit)


+ (void)jj_exchangeIMP{
    [self jj_exchangeOriginalSelector:@selector(willMoveToSuperview:) swizzledSelector:@selector(jj_willMoveToSuperview:)];
}

- (void)jj_willMoveToSuperview:(nullable UIView *)newSuperview{
    [self jj_willMoveToSuperview:newSuperview];
    if ([self jj_isCloseFontFit]) {
        return;
    }
    if (!self.jj_isMoveToSuperview) {
        self.jj_isMoveToSuperview = YES;
        [self jj_setupFontSize];
    }
}

- (BOOL)jj_isCloseFontFit{
    NSArray *colseClass = [JJFontFit shareFontFit].jj_closeClass;
    if (colseClass.count) {
        for (NSString *classString in colseClass) {
            
            if ([self isKindOfClass:NSClassFromString(classString)]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)jj_setupFont{
    //判断是否进入适配状态
    if (!self.jj_isFontFiting&&self.jj_isMoveToSuperview) {
        [self jj_setupFontSize];
    }
}

- (void)jj_setupFontSize{

    if(!self.jj_isFontFit){
        self.jj_isFontFiting = YES;
        [self jj_updateFont];
        self.jj_isFontFiting = NO;
    }
    
}

- (void)jj_updateFont{
    
}


- (void)setJj_isFontFiting:(BOOL)jj_isFontFiting{
    objc_setAssociatedObject(self, @selector(jj_isFontFiting), @(jj_isFontFiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jj_isFontFiting{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJj_isMoveToSuperview:(BOOL)jj_isMoveToSuperview{
    objc_setAssociatedObject(self, @selector(jj_isMoveToSuperview), @(jj_isMoveToSuperview), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jj_isMoveToSuperview{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJj_originalFont:(UIFont *)jj_originalFont{
    objc_setAssociatedObject(self, @selector(jj_originalFont), jj_originalFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)jj_originalFont{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJj_isFontFit:(BOOL)jj_isFontFit{
    objc_setAssociatedObject(self, @selector(jj_isFontFit), @(jj_isFontFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)jj_isFontFit{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}


+ (void)jj_exchangeOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



@end


@implementation UILabel (JJFontFit)


JJ_LOAD(^{

    [self jj_exchangeOriginalSelector:@selector(willMoveToSuperview:) swizzledSelector:@selector(jj_labelWillMoveToSuperview:)];
     [self jj_exchangeOriginalSelector:@selector(setFont:) swizzledSelector:@selector(jj_setLabelFont:)];
});


- (void)jj_labelWillMoveToSuperview:(nullable UIView *)newSuperview{
    [self jj_labelWillMoveToSuperview:newSuperview];
    if ([self jj_isCloseFontFit]) {
        return;
    }
    
    if (!self.jj_isMoveToSuperview) {
        
        NSString *selfClassString = NSStringFromClass(self.class);
        if ([selfClassString hasPrefix:@"UI"]||[selfClassString hasPrefix:@"_UI"]) {
            //说明是UILabel类
            if ([NSStringFromClass(self.class) isEqualToString:@"UILabel"]&&![NSStringFromClass([newSuperview class]) isEqualToString:@"_UINavigationBarContentView"]) {
//                NSLog(@"====%@+===%@==",selfClassString,NSStringFromClass([newSuperview class]));
                [self jj_updateMoveToSuperviewFont];
                return;
            }else{
                
                NSArray *labelClass = [JJFontFit shareFontFit].jj_labelClass;
                if (labelClass.count) {
                    for (NSString *labelString in labelClass) {
                        if ([self isKindOfClass:NSClassFromString(labelString)]) {
                            [self jj_updateMoveToSuperviewFont];
                            return;
                        }
                    }
                    
                }

                    //说明是UIButton的Label
                if ([selfClassString isEqualToString:@"UIButtonLabel"]&&[newSuperview isKindOfClass:[UIButton class]]) {
                    if ([self jj_isCloseFontFit]) {
                        return;
                    }
                    
                    NSString *superClassString = NSStringFromClass([newSuperview class]);
                    //说明是系统的UIButton原类
                    if ([superClassString isEqualToString:@"UIButton"]) {
                        [self jj_updateMoveToSuperviewFont];
                        return;
                    }
                    if ([superClassString hasPrefix:@"UI"]||[superClassString hasPrefix:@"_UI"]) {
                        
                            NSArray *buttonClass = [JJFontFit shareFontFit].jj_buttonClass;
                            if (buttonClass.count) {
                                for (NSString *buttonString in buttonClass) {
                                    if ([newSuperview isKindOfClass:NSClassFromString(buttonString)]) {
                                        [self jj_updateMoveToSuperviewFont];
                                        return;
                                    }
                                }
                                
                            }
                    }else{
                        [self jj_updateMoveToSuperviewFont];
                        return;
                    }
                }

            }
            
        }else{
            //说明是自定义的不是以“UI”，“_UI”开头的UILabel继承类
            [self jj_updateMoveToSuperviewFont];
            return;
        }
    }
}

- (void)jj_updateMoveToSuperviewFont{
    self.jj_isMoveToSuperview = YES;
    [self jj_setupFontSize];
}



- (void)jj_setLabelFont:(UIFont *)font{
    [self jj_setLabelFont:font];
    [self jj_setupFont];
}

- (void)jj_updateFont{
    
    //存储旧的font
    self.jj_originalFont = self.font;
    [JJFontFit jj_updateFontWithView:self];
}

- (void)setIsNotFontFit:(BOOL)isNotFontFit{
     self.jj_isFontFit = isNotFontFit;
    objc_setAssociatedObject(self, @selector(isNotFontFit), @(isNotFontFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isNotFontFit&&self.jj_originalFont) {
        self.font = self.jj_originalFont;
    }
}
- (BOOL)isNotFontFit{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@implementation UIButton (JJFontFit)


- (void)setIsNotFontFit:(BOOL)isNotFontFit{
    
    self.titleLabel.isNotFontFit = isNotFontFit;
}
- (BOOL)isNotFontFit{
    
    return self.titleLabel.isNotFontFit;
}

@end


@implementation UITextView (JJFontFit)
JJ_LOAD(^{
     [self jj_exchangeIMP];
     [self jj_exchangeOriginalSelector:@selector(setFont:) swizzledSelector:@selector(jj_setTextViewFont:)];
});

- (void)jj_setTextViewFont:(UIFont *)font{
    [self jj_setTextViewFont:font];
    [self jj_setupFont];
}

- (void)jj_updateFont{
    //存储旧的font
    self.jj_originalFont = self.font;
//    self.font = [UIFont fontWithDescriptor:self.font.fontDescriptor size:self.font.pointSize*self.fontFitRate];
    [JJFontFit jj_updateFontWithView:self];
}

- (void)setIsNotFontFit:(BOOL)isNotFontFit{
    self.jj_isFontFit = isNotFontFit;
    objc_setAssociatedObject(self, @selector(isNotFontFit), @(isNotFontFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isNotFontFit&&self.jj_originalFont) {
        self.font = self.jj_originalFont;
    }
}

- (BOOL)isNotFontFit{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}


@end

@implementation UITextField (JJFontFit)

JJ_LOAD(^{
    [self jj_exchangeIMP];
    [self jj_exchangeOriginalSelector:@selector(setFont:) swizzledSelector:@selector(jj_setTextFieldFont:)];
});

- (void)jj_setTextFieldFont:(UIFont *)font{
    [self jj_setTextFieldFont:font];
    [self jj_setupFont];
}

- (void)jj_updateFont{
    //存储旧的font
    self.jj_originalFont = self.font;
    [JJFontFit jj_updateFontWithView:self];
}

- (void)setIsNotFontFit:(BOOL)isNotFontFit{
    self.jj_isFontFit = isNotFontFit;
    objc_setAssociatedObject(self, @selector(isNotFontFit), @(isNotFontFit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isNotFontFit&&self.jj_originalFont) {
        self.font = self.jj_originalFont;
    }
    
}
- (BOOL)isNotFontFit{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}



@end
