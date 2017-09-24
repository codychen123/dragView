//
//  UIView+dragable.h
//  dragDemo
//
//  Created by xiaohuihui on 2017/9/17.
//  Copyright © 2017年 xiaohuihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (dragable)

- (void)addDragableActionWithEnd:(void (^)(CGRect endFrame))endBlock;

@end
