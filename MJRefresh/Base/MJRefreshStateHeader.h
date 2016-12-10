//
//  MJRefreshStateHeader.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/11.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshStateHeader : MJRefreshHeader
#pragma mark - 刷新时间相关
/**
 *  利用这个block来显示的更新时间文字
 */
@property (nonatomic, copy) NSString *(^lastUpdatedTimeText)(NSDate * lastUpdatedTime);
/**
 *  显示上一次刷新时间的label
 */
@property (nonatomic, weak, readonly) UILabel * lastUpdateTimeLabel;

#pragma mark - 状态相关
/**文字距离 圈圈／箭头 的距离*/
@property (nonatomic, assign) CGFloat labelLeftInset;
/** 刷新状态的label */
@property (nonatomic, weak, readonly) UILabel * stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@end
