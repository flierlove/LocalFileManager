//
//  MJRefreshGifHeader.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/11.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshGifHeader : MJRefreshStateHeader
@property (nonatomic, weak, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 和动画持续时间 duration */
- (void)setImages:(NSArray *)images duration:(CGFloat)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
