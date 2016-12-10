//
//  MJRefreshComponent.m
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/3.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshComponent()
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation MJRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    //准备工作
    [self prepare];
    //默认是普通状态
    self.state = MJRefreshStateIdle;
  }
  return self;
}

- (void)prepare
{
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
  [self placeSubviews];
  [super layoutSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [super willMoveToSuperview:newSuperview];
  
  //如果不是ScrollView，不做任何事
  if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
  
  //旧的父控件移除监听
  [self removeObservers];
  
  if (newSuperview)//新的父控件
  {
    //设置宽度
    self.mj_width = newSuperview.mj_width;
    //设置位置
    self.mj_x = 0;
    
    //记录scrollview
    _scrollView = (UIScrollView *)newSuperview;
    //设置scrollview永远支持垂直弹簧效果
    _scrollView.alwaysBounceVertical = YES;
    //记录scrollview最开始的contentInset
    _scrollViewOrginInset = _scrollView.contentInset;
    
    //添加监听
    [self addObservers];
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (self.state == MJRefreshStateWillRefresh)
  {
    //防止view还未显示出来就调用了beginRefreshing
    self.state = MJRefreshStateRefreshing;
  }
}

#pragma mark - KVO 监听

- (void)addObservers
{
  NSKeyValueObservingOptions option = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
  [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:option context:nil];
  [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:option context:nil];
  self.pan = self.scrollView.panGestureRecognizer;
  [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState options:option context:nil];
}

- (void)removeObservers
{
  [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
  [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];
  [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
  self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  //view被设置为不响应触摸操作 直接返回
  if (!self.userInteractionEnabled) return;
  //这个就算看不见也要处理
  if ([keyPath isEqualToString:MJRefreshKeyPathContentSize])
  {
    [self scrollViewContentSizeDidChange:change];
  }
  
  if (self.hidden) return;
  
  if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset])
  {
    [self scrollViewContentOffsetDidChange:change];
  }
  else if ([keyPath isEqualToString:MJRefreshKeyPathPanState])
  {
    [self scrollViewPanStateDidChange:change];
  }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)dictionary{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)dictionary{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)dictionary{}

#pragma mark - 公共方法
#pragma mark - 设置代理和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
  self.refreshingTarget = target;
  self.refreshingAction = action;
}

- (void)setState:(MJRefreshState)state
{
  _state = state;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self setNeedsDisplay];
  });
}

#pragma mark - 进入刷新状态
- (void)beginRefreshing
{
  [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
    self.alpha = 1.0;
  }];
  
  self.pullPercent = 1.0;
  //只要正在刷新，就完全显示
  if (self.window)
  {
    self.state = MJRefreshStateRefreshing;
  }
  else
  {
    //预防正在刷新时，调用本方法使得head inset回调失败
    if(self.state != MJRefreshStateRefreshing)
    {
      self.state = MJRefreshStateWillRefresh;
      //刷新，预防从另一个控制器回到这个控制器的情况，需要刷新一下
      [self setNeedsDisplay];
    }
  }
}

- (void)beginRefreshingWithCompletionBlock:(MJRefreshComponentBeginRefreshingCompletionBlock)block
{
  self.beginRefreshingCompletionBlock = block;
  [self beginRefreshing];
}

#pragma mark - 结束刷新状态
- (void)endRefreshing
{
  self.state = MJRefreshStateIdle;
}

- (void)endRefreshingWithCompletionBlock:(void (^)())block
{
  self.endRefreshingCompletionBlock = block;
  [self endRefreshing];
}

#pragma mark - 是否正在刷新
- (BOOL)isRefreshing
{
  return self.state == MJRefreshStateRefreshing || self.state == MJRefreshStateWillRefresh;
}

#pragma mark - 自动切换透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
  self.automaticallyChangeAlpha = autoChangeAlpha;
}

- (BOOL)isAutoChangeAlpha
{
  return self.isAutomaticallyChangeAlpha;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
  _automaticallyChangeAlpha = automaticallyChangeAlpha;
  
  if (self.isRefreshing) return;
  
  if (automaticallyChangeAlpha)
  {
    self.alpha = self.pullPercent;
  }
  else
  {
    self.alpha = 1.0;
  }
}

#pragma mark - 根据设置透明度
- (void)setPullPercent:(CGFloat)pullPercent
{
  _pullPercent = pullPercent;
  if (self.isRefreshing) return;
  
  if (self.isAutomaticallyChangeAlpha)
  {
    self.alpha = pullPercent;
  }
}

#pragma mark - 内部方法
- (void)excuteRefreshingCallback
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.refreshingBlock)
    {
      self.refreshingBlock();
    }
    
    if ([self.refreshingTarget respondsToSelector:self.refreshingAction])
    {
      MJRefreshMsgSend(MJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
    }
    if (self.beginRefreshingCompletionBlock)
    {
      self.beginRefreshingCompletionBlock();
    }
  });
}

@end

@implementation UILabel (MJExtention)

+ (instancetype)mj_label
{
  UILabel * label = [[self alloc]init];
  [label setFont:MJRefreshLabelFont];
  label.textColor = MJRefreshLabelTextColor;
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  return label;
}

- (CGFloat)mj_textWidth
{
  CGFloat stringWidth = 0;
  CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
  if (self.text.length > 0)
  {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    stringWidth = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
#else
    stringWidth = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakCharWrapping].width;
#endif
  }
  return stringWidth;
}

@end
