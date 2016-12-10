//
//  UIScrollView+MJExtention.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/8.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJExtension)

@property (nonatomic, assign) CGFloat mj_insetT;
@property (nonatomic, assign) CGFloat mj_insetB;
@property (nonatomic, assign) CGFloat mj_insetL;
@property (nonatomic, assign) CGFloat mj_insetR;

@property (nonatomic, assign) CGFloat mj_offsetX;
@property (nonatomic, assign) CGFloat mj_offsetY;

@property (nonatomic, assign) CGFloat mj_contentW;
@property (nonatomic, assign) CGFloat mj_contentH;

@end
