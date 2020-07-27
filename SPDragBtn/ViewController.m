//
//  ViewController.m
//  SPDragBtn
//
//  Created by Jared on 2020/7/27.
//  Copyright © 2020 Jared. All rights reserved.
//

#import "ViewController.h"
#import "UIViewExt.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic,strong)UIButton *spButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //创建可拖动、自动贴近边缘的 事件上报按钮
    [self initAddEventBtn];
}

-(void)initAddEventBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-71,300,66,66)];
//    [btn setImage:[UIImage imageNamed:@"shijianshangbao"]  forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor colorWithWhite:0.88 alpha:0.8];
    btn.backgroundColor = UIColor.redColor;
    btn.tag = 0;
    btn.layer.cornerRadius = 8;
    [self.view addSubview:btn];
    self.spButton = btn;
    [_spButton addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [btn addGestureRecognizer:panRcognize];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
       case UIGestureRecognizerStateBegan:
          
          break;
       case UIGestureRecognizerStateChanged:
       {
           CGPoint translation = [recognizer translationInView:self.navigationController.view];
          recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
       }
          break;
       case UIGestureRecognizerStateEnded:
       {
           CGPoint stopPoint = CGPointMake(0, SCREEN_HEIGHT / 2.0);
          
           if (recognizer.view.center.x < SCREEN_WIDTH / 2.0) {
              if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                 //左上
                 if (recognizer.view.center.x  >= recognizer.view.center.y) {
                     stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                     NSLog(@"上边缘-偏左");
                 }else{
                     stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                     NSLog(@"左边缘");
                 }
              }else{
                 //左下
                 if (recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                     stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                     NSLog(@"下边缘-偏左");
                 }else{
                     stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                     NSLog(@"左边缘");
//                     stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                 }
              }
          }else{
              if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                 //右上
                 if (SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                     stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                     NSLog(@"上边缘-偏右");
                 }else{
                     stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, recognizer.view.center.y);
                     NSLog(@"右边缘");
                 }
              }else{
                 //右下
                 if (SCREEN_WIDTH - recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                     stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                     NSLog(@"下边缘-偏右");
                 }else{
                     stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0,recognizer.view.center.y);
                     NSLog(@"右边缘");
                 }
              }
           }
          
          //如果按钮超出屏幕边缘
           if (stopPoint.y + self.spButton.width+40>= SCREEN_HEIGHT) {
              stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.spButton.width/2.0-49);
              NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
           }
           if (stopPoint.x - self.spButton.width/2.0 <= 0) {
              stopPoint = CGPointMake(self.spButton.width/2.0, stopPoint.y);
           }
           if (stopPoint.x + self.spButton.width/2.0 >= SCREEN_WIDTH) {
              stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, stopPoint.y);
           }
           if (stopPoint.y - self.spButton.width/2.0 <= 0) {
              stopPoint = CGPointMake(stopPoint.x, self.spButton.width/2.0);
           }
  
           [UIView animateWithDuration:0.5 animations:^{
              recognizer.view.center = stopPoint;
           }];
       }
          break;
          
       default:
          break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)addEvent{
    NSLog(@"点击按钮");
}

@end
