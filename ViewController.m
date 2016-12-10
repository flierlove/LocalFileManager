//
//  ViewController.m
//  LocalFileManager
//
//  Created by F1052062 on 16/12/9.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "ViewController.h"
#import "UIView+MJExtention.h"
#import "UIScrollView+MJExtention.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshGifHeader.h"

#import "PiNFileManager.h"
#import "LocalFileModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
  PiNFileManager * pinFileManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  __unsafe_unretained UITableView * tableView = self.tableView;
  tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (!pinFileManager)
      {
        pinFileManager = [[PiNFileManager alloc]init];
      }
      
      [pinFileManager rootDocumentList];
      [tableView reloadData];
      [tableView.mj_header endRefreshing];
    });
  }];
  
  tableView.mj_header.automaticallyChangeAlpha = YES;
  [tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Method
- (IBAction)addFoler:(UIButton *)sender
{
  NSError * error;
  [pinFileManager addFolerWithName:[NSString stringWithFormat:@"test%ld",(long)sender.tag] error:&error];
  sender.tag += 1;
  
  if (error)
  {
    NSLog(@"%@",error);
  }
  else
  {
    NSLog(@"success");
    [self.tableView reloadData];
  }
}
- (IBAction)foreDirectory:(UIButton *)sender
{
  [pinFileManager foreFolder];
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return pinFileManager.currentFileModel.subPaths.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocalFileTableViewCell" forIndexPath:indexPath];
  LocalFileModel * currentFileModel = pinFileManager.currentFileModel.subPaths[indexPath.row];
  cell.textLabel.text = currentFileModel.name;
  NSLog(@"name: %@, createDate: %@, fileType: %@, fileSize: %@",currentFileModel.name, currentFileModel.createDate, currentFileModel.fileType, currentFileModel.fileSize);
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LocalFileModel * currentFileModel = pinFileManager.currentFileModel.subPaths[indexPath.row];
  [pinFileManager openFileWithFileModel:currentFileModel];
  [self.tableView reloadData];
}

@end
