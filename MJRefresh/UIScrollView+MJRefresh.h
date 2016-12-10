//
//  UIScrollView+MJRefresh.h
//  MJrefreshCopy
//
//  Created by F1052062 on 16/11/8.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"

@class MJRefreshHeader;

@interface UIScrollView(MJRefresh)

@property (nonatomic, strong) MJRefreshHeader * mj_header;

#pragma mark - Others

- (NSInteger)mj_TotalCount;
@property (nonatomic, copy) void (^mj_reloadDataBlock)(NSInteger totalCount);

@end
