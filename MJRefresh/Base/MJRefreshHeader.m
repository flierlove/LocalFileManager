//
//  MJRefreshHeader.m
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/8.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshHeader()
@property (nonatomic, assign) CGFloat insetTDelta;
@end

@implementation MJRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
  MJRefreshHeader * cmp = [[self alloc]init];
  cmp.refreshingBlock = refreshingBlock;
  return cmp;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
  MJRefreshHeader * cmp = [[self alloc]init];
  cmp.refreshingTarget = target;
  cmp.refreshingAction = action;
  return cmp;
}

#pragma mark - 覆盖父类的方法

- (void)prepare
{
  [super prepare];
  self.lastUpdateTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
  self.mj_height = MJRefreshHeaderHeight;
}

- (void)placeSubviews
{
  [super placeSubviews];
  //设置y值(当自己的高度改变了，必须要重新设置y值，故将其放在placeSubviews中)
  self.mj_y = -self.mj_height - self.ignoreScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)dictionary
{
  [super scrollViewContentOffsetDidChange:dictionary];
  
  //在刷新的refreshing状态
  if (self.state == MJRefreshStateRefreshing)
  {
    if (self.window == nil) return;
    
    CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOrginInset.top ? -self.scrollView.mj_offsetY : _scrollViewOrginInset.top;
    insetT = insetT > self.mj_height + _scrollViewOrginInset.top ? _scrollViewOrginInset.top + self.mj_height : insetT;
    self.scrollView.mj_insetT = insetT;
    
    self.insetTDelta = _scrollViewOrginInset.top - insetT;
    return;
  }
  
  //跳转到下一个控制器时，contentInset可能发生改变
  _scrollViewOrginInset = self.scrollView.contentInset;
  
  //当前的contentOffsetY
  CGFloat offsetY = self.scrollView.contentOffset.y;
  //head刚好完全出现的offsetY
  CGFloat happenOffsetY = -_scrollViewOrginInset.top;
  
  //如果是向上滚动看不见head，直接返回
  if (offsetY > happenOffsetY) return;
  
  //普通临界点 和 即将刷新的临界点
  CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_height;
  CGFloat pullingPercent = (happenOffsetY - offsetY)/self.mj_height;
  
  if (self.scrollView.isDragging)
  {
    //如果正在拖拽
    self.pullPercent = pullingPercent;
    if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY)
    {
      //转为即将刷新状态
      self.state = MJRefreshStatePulling;
    }
    else if (self.state == MJRefreshStatePulling && offsetY > normal2pullingOffsetY)
    {
      //转为普通状态
      self.state = MJRefreshStateIdle;
    }
  }
  else if (self.state == MJRefreshStatePulling)//即将刷新&&手松开
  {
    [self beginRefreshing];
  }
  else if (pullingPercent < 1)
  {
    self.pullPercent = pullingPercent;
  }
}

- (void)setState:(MJRefreshState)state
{
  MJRefreshCheckState
  
  if (state == MJRefreshStateIdle)
  {
    //现状态为 Idle, 若之前不是刷新状态, 则不需要做任何事
    if (oldState != MJRefreshStateRefreshing) return;
    
    //之前状态是刷新状态
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdateTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //恢复inset和offset
    [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
      self.scrollView.mj_insetT += self.insetTDelta;
      
      //调整透明度
      if (self.isAutomaticallyChangeAlpha)
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
      self.pullPercent = 0.0;
      
      if (self.endRefreshingCompletionBlock) {
        self.endRefreshingCompletionBlock();
      }
    }];
  }
  else if (state == MJRefreshStateRefreshing)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
        CGFloat top = self.scrollViewOrginInset.top + self.mj_height;
        //增加滚动区域Top
        self.scrollView.mj_insetT = top;
        //设置滚动位置
        self.scrollView.contentOffset = CGPointMake(0, -top);
      } completion:^(BOOL finished) {
        [self excuteRefreshingCallback];
      }];
    });
  }
}

- (void)endRefreshing
{
  dispatch_async(dispatch_get_main_queue(), ^{
    self.state = MJRefreshStateIdle;
  });
}

- (NSDate *)lastUpdateTime
{
  return [[NSUserDefaults standardUserDefaults] valueForKey:self.lastUpdateTimeKey];
}

@end
