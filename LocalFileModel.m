//
//  LocalFileModel.m
//  LocalFileManager
//
//  Created by F1052062 on 16/12/9.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import "LocalFileModel.h"

@implementation LocalFileModel

- (void)updateArrtributeWith:(NSDictionary *)attributeDictionary
{
  self.createDate = attributeDictionary[NSFileCreationDate];
  self.fileType = attributeDictionary[NSFileType];
  self.fileSize = attributeDictionary[NSFileSize];
}

@end
