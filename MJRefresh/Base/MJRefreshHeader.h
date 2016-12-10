//
//  MJRefreshHeader.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/8.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshHeader : MJRefreshComponent

/*** 创建Header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/*** 创建Header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/*** 存储上一次下拉刷新时间的Key */
@property (nonatomic, copy) NSString * lastUpdateTimeKey;
/*** 上一次下拉刷新时间 */
@property (nonatomic, strong, readonly) NSDate * lastUpdateTime;

/*** 忽略多少ScrollView 的contentInset的top */
@property (nonatomic, assign) CGFloat ignoreScrollViewContentInsetTop;

@end
