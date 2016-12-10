//
//  LocalFileModel.h
//  LocalFileManager
//
//  Created by F1052062 on 16/12/9.
//  Copyright © 2016年 F1052062. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalFileModel : NSObject

@property (nonatomic, strong) LocalFileModel * parentFileModel;
@property (nonatomic, strong) NSString * name;
/**
 *  路径
 */
@property (nonatomic, strong) NSString * path;
@property (nonatomic, strong) NSArray * subPaths;

@property (nonatomic, strong) NSDate * createDate;
@property (nonatomic, strong) NSString * fileSize;
@property (nonatomic, strong) NSString * fileType;

- (void)updateArrtributeWith:(NSDictionary *)attributeDictionary;

@end
