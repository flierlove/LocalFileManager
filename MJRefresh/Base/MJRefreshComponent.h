//
//  MJRefreshComponent.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/3.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtention.h"
#import "UIScrollView+MJExtention.h"
#import "UIScrollView+MJRefresh.h"

/**
 *  刷新控件的状态
 */
typedef NS_ENUM(NSInteger, MJRefreshState)
{
  /***  普通闲置状态 */
  MJRefreshStateIdle = 1,
  /***  松开就可以进行刷新的状态 */
  MJRefreshStatePulling,
  /***  正在刷新的状态 */
  MJRefreshStateRefreshing,
  /***  即将刷新的状态 */
  MJRefreshStateWillRefresh,
  /***  所有数据加载完毕，没有更多数据状态 */
  MJRefreshStateNoMoreData
};

/*** 进入刷新状态的回调 */
typedef void (^MJRefreshComponentRefreshingBlock)();
/*** 开始刷新后的回调(进入刷新状态后的回调） */
typedef void (^MJRefreshComponentBeginRefreshingCompletionBlock)();
/*** 结束刷新状态的回调 */
typedef void (^MJRefreshComponentEndRefreshingCompletionBlock)();


/*** 刷新控件的基类 */
@interface MJRefreshComponent : UIView
{
  /*** 记录ScrollView刚开始的inset */
  UIEdgeInsets _scrollViewOrginInset;
  /*** 父控件 */
  __weak UIScrollView * _scrollView;
}

#pragma mark - 
#pragma mark - 刷新回调
/*** 正在刷新的回调 */
@property (nonatomic, copy) MJRefreshComponentRefreshingBlock refreshingBlock;
/*** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

/*** 回调对象 */
@property (nonatomic, weak) id refreshingTarget;
/*** 回调方法 */
@property (nonatomic, assign) SEL refreshingAction;
/*** 触发回调(交给子类去调用) */
- (void)excuteRefreshingCallback;

#pragma mark - 刷新状态控制
/*** 进入刷新状态 */
- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(MJRefreshComponentBeginRefreshingCompletionBlock)block;
/*** 进入刷新状态的回调(开始刷新的回调) */
@property (nonatomic, copy)MJRefreshComponentBeginRefreshingCompletionBlock beginRefreshingCompletionBlock;
/*** 结束刷新状态的回调 */
@property (nonatomic, copy)MJRefreshComponentEndRefreshingCompletionBlock endRefreshingCompletionBlock;

/*** 结束刷新状态 */
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void(^)())block;

/*** 是否正在刷新 */
- (BOOL)isRefreshing;
/*** 刷新状态(交由子类实现) */
@property (nonatomic, assign) MJRefreshState state;

#pragma mark - 交给子类访问
/*** 记录scrollview刚开始的初始EdgeInset */
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOrginInset;
/*** 父控件 */
@property (nonatomic, weak, readonly) UIScrollView * scrollView;

#pragma mark - 交给子类去实现
/*** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/*** 摆放子控件frame */
- (void)placeSubviews NS_REQUIRES_SUPER;
/*** 当ScrollView的ContentOffset发生变化时调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)dictionary NS_REQUIRES_SUPER;
/*** 当ScrollView的ContentSize发生变化时调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)dictionary NS_REQUIRES_SUPER;
/*** 当ScrollView的拖拽状态发生改变时调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)dictionary NS_REQUIRES_SUPER;

#pragma mark - 其他
/*** 拉拽百分比 */
@property (nonatomic, assign) CGFloat pullPercent;
/*** 根据拖拽百分比自动切换透明度 */
@property (nonatomic, assign, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");
/*** 根据拖拽百分比自动切换透明度 */
@property (nonatomic, assign, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;

@end

@interface UILabel (MJRefresh)

+ (instancetype)mj_label;
- (CGFloat)mj_textWidth;

@end

