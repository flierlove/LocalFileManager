//
//  MJRefreshStateHeader.m
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/11.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshStateHeader()
{
  //上次刷新时间Label
  __unsafe_unretained UILabel * _lastUpdateTimeLable;
  //刷新状态
  __weak UILabel * _stateLabel;
}
//所有状态对应的文字
@property (nonatomic, strong) NSMutableDictionary * stateTitles;
@end

@implementation MJRefreshStateHeader
#pragma mark - Lazy Load
- (NSMutableDictionary *)stateTitles
{
  if (!_stateTitles)
  {
    self.stateTitles = [NSMutableDictionary dictionary];
  }
  return _stateTitles;
}

- (UILabel *)stateLabel
{
  if (!_stateLabel)
  {
    [self addSubview:_stateLabel = [UILabel mj_label]];
  }
  return _stateLabel;
}

- (UILabel *)lastUpdateTimeLabel
{
  if (!_lastUpdateTimeLable)
  {
    [self addSubview:_lastUpdateTimeLable = [UILabel mj_label]];
  }
  return _lastUpdateTimeLable;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
  if (title == nil)
    return;
  
  self.stateTitles[@(state)] = title;
  self.stateLabel.text = self.stateTitles[@(state)];
}

//iOS9之后使用currentCalendar会有问题
- (NSCalendar *)currentCalendar
{
  if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)])
  {
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  }
  return [NSCalendar currentCalendar];
}

#pragma mark - Key 处理
- (void)setLastUpdateTimeKey:(NSString *)lastUpdateTimeKey
{
  [super setLastUpdateTimeKey:lastUpdateTimeKey];
  
  //label 隐藏了就不进行处理
  if (self.lastUpdateTimeLabel.hidden)
  {
    return;
  }
  
  NSDate * lastUpdateTime = [[NSUserDefaults standardUserDefaults]valueForKey:lastUpdateTimeKey];
  
  if (self.lastUpdatedTimeText)
  {
    self.lastUpdateTimeLabel.text = self.lastUpdatedTimeText(lastUpdateTime);
    return;
  }
}

#pragma mark - 父类的方法
- (void)prepare
{
  [super prepare];
  self.labelLeftInset = MJRefreshLabelLeftInset;
  
  [self setTitle:@"Idle" forState:MJRefreshStateIdle];
  [self setTitle:@"Pulling" forState:MJRefreshStatePulling];
  [self setTitle:@"Refreshing" forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
  [super placeSubviews];
  
  if (self.stateLabel.hidden) return;
  
  BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
  
  if (self.lastUpdateTimeLabel.hidden) {
    // 状态
    if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
  } else {
    CGFloat stateLabelH = self.mj_height * 0.5;
    // 状态
    if (noConstrainsOnStatusLabel) {
      self.stateLabel.backgroundColor = [UIColor redColor];
      self.stateLabel.mj_x = 0;
      self.stateLabel.mj_y = 0;
      self.stateLabel.mj_width = self.mj_width;
      self.stateLabel.mj_height = stateLabelH;
    }
    
    // 更新时间
    if (self.lastUpdateTimeLabel.constraints.count == 0) {
      self.lastUpdateTimeLabel.mj_x = 0;
      self.lastUpdateTimeLabel.mj_y = stateLabelH;
      self.lastUpdateTimeLabel.mj_width = self.mj_width;
      self.lastUpdateTimeLabel.mj_height = self.mj_height - self.lastUpdateTimeLabel.mj_y;
    }
  }
}

- (void)setState:(MJRefreshState)state
{
  MJRefreshCheckState
  
  //设置状态文字
  self.stateLabel.text = self.stateTitles[@(state)];
  //设置显示时间
  self.lastUpdateTimeKey = self.lastUpdateTimeKey;
}

@end
