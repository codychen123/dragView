//
//  UIView+dragable.m
//  dragDemo
//
//  Created by xiaohuihui on 2017/9/17.
//  Copyright © 2017年 xiaohuihui. All rights reserved.
//

#import "UIView+dragable.h"
#import <objc/runtime.h>

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

static const char *ActionHandlerPanGestureKey;

@implementation UIView (dragable)

- (void)addDragableActionWithEnd:(void (^)(CGRect endFrame))endBlock; {
    // 添加拖拽手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    // 记录block
    objc_setAssociatedObject(self, ActionHandlerPanGestureKey, endBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];
    
    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;
    
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 12) {
                viewCenter.x = senderHalfViewWidth + 12;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= (ScreenWidth - 12)) {
                viewCenter.x = ScreenWidth - senderHalfViewWidth - 12;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 12) {
                viewCenter.y = senderHalfViewHeight + 12;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (ScreenHeight - 12)) {
                viewCenter.y = ScreenHeight - senderHalfViewHeight - 12;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {
            void (^endBlock)(CGRect endFrame) = objc_getAssociatedObject(self, ActionHandlerPanGestureKey);
            if (endBlock) {
                endBlock(sender.view.frame);
            }
        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else {
        // UIGestureRecognizerStateBegan || UIGestureRecognizerStateChanged
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }
}

@end
