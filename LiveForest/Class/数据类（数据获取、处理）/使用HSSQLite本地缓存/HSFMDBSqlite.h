//
//  HSFMDBSqlite.h
//  LiveForest
//
//  Created by 微光 on 15/5/6.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>


@interface HSFMDBSqlite : NSObject

@property (nonatomic, strong) FMDatabase *db;

//保存数据数组
- (void)saveDataList:(NSString *)tableName andData:(NSString*)data;
//查询数据数组
- (NSString *)queryData:(NSString *)tableName;
//删除数据
- (BOOL)removeTable:(NSString *)tableName;

// 更新表内容
- (void)updateData:(NSString *)tableName andData:(NSString *)data;

//判断是否存在
//- (BOOL)existTableData:(NSString *)tableName;

@end
