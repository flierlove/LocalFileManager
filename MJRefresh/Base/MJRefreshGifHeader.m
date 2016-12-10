//
//  MJRefreshGifHeader.m
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/11.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface MJRefreshGifHeader()
{
  __weak UIImageView * _gifView;
}
/**
 *  所有状态对应的动画图片
 */
@property (nonatomic, strong) NSMutableDictionary * stateImages;
/**
 *  所有状态对应的动画时间
 */
@property (nonatomic, strong) NSMutableDictionary * stateDurations;
@end
@implementation MJRefreshGifHeader
#pragma mark - Lazy Load
- (UIImageView *)gifView
{
  if (!_gifView)
  {
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:_gifView=imageView];
  }
  return _gifView;
}

- (NSMutableDictionary *)stateImages
{
  if (!_stateImages)
  {
    self.stateImages = [NSMutableDictionary dictionary];
  }
  return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
  if (!_stateDurations)
  {
    self.stateDurations = [NSMutableDictionary dictionary];
  }
  return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(CGFloat)duration forState:(MJRefreshState)state
{
  if (images == nil)
  {
    return;
  }
  
  self.stateImages[@(state)] = images;
  self.stateDurations[@(state)] = @(duration);
  
  //根据图片设置控件的高度
  UIImage * image = [images firstObject];
  if (image.size.height > self.mj_height)
  {
    self.mj_height = image.size.height;
  }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
  [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 父类方法
- (void)prepare
{
  [super prepare];
  self.labelLeftInset = 20;
  
  // 设置普通状态的动画图片
  NSMutableArray *idleImages = [NSMutableArray array];
  for (NSUInteger i = 1; i<=60; i++) {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
    [idleImages addObject:image];
  }
  [self setImages:idleImages forState:MJRefreshStateIdle];
  
  // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
  NSMutableArray *refreshingImages = [NSMutableArray array];
  for (NSUInteger i = 1; i<=3; i++) {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
    [refreshingImages addObject:image];
  }
  [self setImages:refreshingImages forState:MJRefreshStatePulling];
  
  // 设置正在刷新状态的动画图片
  [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

- (void)setPullPercent:(CGFloat)pullPercent
{
  [super setPullPercent:pullPercent];
  NSArray * images = self.stateImages[@(MJRefreshStateIdle)];
  if (self.state != MJRefreshStateIdle || images.count == 0)
  {
    return;
  }
  
  //停止动画
  [self.gifView stopAnimating];
  //设置当前需要显示的图片
  NSInteger index = images.count * pullPercent;
  if (index >= images.count)
  {
    index = images.count - 1;
  }
  self.gifView.image = images[index];
}

- (void)placeSubviews
{
  [super placeSubviews];
  
  if (self.gifView.constraints.count)
  {
    return;
  }
  
  self.gifView.frame = self.bounds;
  if (self.stateLabel.hidden && self.lastUpdateTimeLabel.hidden)
  {
    self.gifView.contentMode = UIViewContentModeCenter;
  }
  else
  {
    self.gifView.contentMode = UIViewContentModeRight;
    CGFloat stateWidth = self.stateLabel.mj_textWidth;
    CGFloat timeWidth = 0.0;
    if (!self.lastUpdateTimeLabel.hidden)
    {
      timeWidth = self.lastUpdateTimeLabel.mj_textWidth;
    }
    CGFloat textWidth = MAX(stateWidth, timeWidth);
    self.gifView.mj_width = self.mj_width * 0.5 - textWidth * 0.5 - self.labelLeftInset;
  }
}

- (void)setState:(MJRefreshState)state
{
  MJRefreshCheckState;
  
  if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing)
  {
    NSArray * images = self.stateImages[@(state)];
    if (images.count == 0) {
      return;
    }
    [self.gifView stopAnimating];
    
    if (images.count == 1)
    {
      self.gifView.image = [images lastObject];
    }
    else
    {
      self.gifView.animationImages = images;
      self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
      [self.gifView startAnimating];
    }
  }
  else if (state == MJRefreshStateIdle)
  {
    [self.gifView stopAnimating];
  }
}

@end
