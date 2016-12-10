//
//  PiNFileManager.m
//  LocalFileManager
//
//  Created by F1052062 on 16/12/9.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "PiNFileManager.h"
#import "LocalFileModel.h"

@implementation PiNFileManager

- (instancetype)init{
  self = [super init];
  if (self)
  {
    fileManager = [NSFileManager defaultManager];
  }
  return self;
}

- (void)rootDocumentList
{
  [self openFileWithFileModel:nil];
}

- (void)openFileWithFileModel:(LocalFileModel *)fileModel
{
  LocalFileModel * openFileModel;
  if (fileModel)//打开文件夹
  {
    openFileModel = fileModel;
  }
  else//打开根目录
  {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * rootPath = [paths objectAtIndex:0];
    openFileModel = [[LocalFileModel alloc]init];
    openFileModel.parentFileModel = nil;
    openFileModel.name = @"Document";
    openFileModel.path = rootPath;
    [openFileModel updateArrtributeWith:[fileManager attributesOfItemAtPath:rootPath error:nil]];
  }
    
  if ([openFileModel.fileType isEqualToString:NSFileTypeDirectory])
  {
    NSArray * subPathsArray = [fileManager contentsOfDirectoryAtPath:openFileModel.path error:nil];
    
    NSMutableArray * subPathsAttribute = [NSMutableArray new];
    for (NSString * subPath in subPathsArray)
    {
      LocalFileModel * currentFileModel = [[LocalFileModel alloc]init];
      currentFileModel.parentFileModel = openFileModel;
      currentFileModel.name = subPath;
      currentFileModel.path = [openFileModel.path stringByAppendingPathComponent:subPath];
      [currentFileModel updateArrtributeWith:[fileManager attributesOfItemAtPath:currentFileModel.path error:nil]];
      [subPathsAttribute addObject:currentFileModel];
    }

    openFileModel.subPaths = subPathsAttribute;
    
    self.currentFileModel = openFileModel;
  }
  else
  {
    
  }
}

- (void)foreFolder
{
  if (self.currentFileModel.parentFileModel)
  {
    self.currentFileModel = self.currentFileModel.parentFileModel;
  }
}

- (void)addFolerWithName:(NSString *)name error:(NSError *__autoreleasing *)error
{
  NSString * path = [self.currentFileModel.path stringByAppendingPathComponent:name];
  [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:error];
}

- (void)deleteFileModel:(LocalFileModel *)fileModel
{
  [fileManager removeItemAtPath:fileModel.path error:nil];
}

- (void)renameFileModel:(LocalFileModel *)fileModel withNewName:(NSString *)name
{
  NSString * newPath = [[fileModel.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:name];
  [fileManager moveItemAtPath:fileModel.path toPath:newPath error:nil];
}

@end
