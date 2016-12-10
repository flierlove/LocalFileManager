//
//  PiNFileManager.h
//  LocalFileManager
//
//  Created by F1052062 on 16/12/9.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LocalFileModel;
@interface PiNFileManager : NSObject
{
  NSFileManager * fileManager;
}

@property (nonatomic, strong) LocalFileModel * currentFileModel;

/**
 *  根目录
 */
- (void)rootDocumentList;
/**
 *  打开文件
 *
 *  @param fileModel 如果是文件夹则进入文件夹, 如果是文件则打开文件
 */
- (void)openFileWithFileModel:(LocalFileModel *)fileModel;

/**
 *  返回上层目录
 */
- (void)foreFolder;

/**
 *  新增文件夹
 *
 *  @param name  文件夹名称
 *  @param error 错误信息, 如果成功则返回 nil
 */
- (void)addFolerWithName:(NSString *)name error:(NSError **)error;
/**
 *  删除文件
 *
 *  @param fileModel 如果是文件夹则删除文件夹及其内容, 如果是文件则删除文件
 */
- (void)deleteFileModel:(LocalFileModel *)fileModel;
/**
 *  重命名文件
 *
 *  @param fileModel 重命名文件/文件夹
 *  @param name 新名字
 */
- (void)renameFileModel:(LocalFileModel *)fileModel withNewName:(NSString *)name;

@end
