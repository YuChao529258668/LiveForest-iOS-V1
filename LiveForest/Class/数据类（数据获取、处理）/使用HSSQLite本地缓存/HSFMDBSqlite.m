//
//  HSFMDBSqlite.m
//  LiveForest
//
//  Created by 微光 on 15/5/6.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSFMDBSqlite.h"

@implementation HSFMDBSqlite

@synthesize db = _db;

-(BOOL)creatDatabase
	{
        
        //paths： ios下Document路径，Document为中ios可读写的文件夹
        
        //创建数据库实例 db 这里说明下:如果路径中不存在”Test.db”的文件,sqlite会自动创建”Test.db”
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //dbPath： 数据库路径，在Document中。
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Test.db"];
        
        _db = [FMDatabase databaseWithPath:dbPath] ;
        if (![_db open]) {
            NSLog(@"Could not open db.");
            return false;
    }
        return true;
}
- (BOOL)creatTable:(NSString*)tableName
{
    
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![_db tableExists:tableName])
    {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (user_id INTEGER PRIMARY KEY , data TEXT)",tableName];

//        [_db executeUpdate:@"CREATE TABLE HSIndexMPTable (user_id INTEGER PRIMARY KEY , Data TEXT)"];//,tableName];
//        [_db executeUpdateWithFormat:@"CREATE TABLE %@ (user_id INTEGER PRIMARY KEY , Data TEXT)",tableName];
        BOOL result = [_db executeUpdate:sql];
        NSLog(@"创建表格完成");
         return result;
    }
    return false;
    
}
//保存数据数组
- (void)saveDataList:(NSString *)tableName andData:(NSString*)data{
   
    
    if (![_db open]) {
        
        if([self creatDatabase]){
            NSLog(@"数据库打开成功");
        }
        else{
            NSLog(@"创建数据库失败,插入数据失败");
            return;
        }
    }
//创建数据库成功
    //todo
    //删除表
//    [self removeTable];
    
    if(![_db tableExists:tableName]){
        NSLog(@"table did not exist:%@",tableName);
        if([self creatTable:tableName]){
            NSLog(@"table 创建成功");
        }
        else{
            NSLog(@"创建表失败，插入失败");
            return;
        }
    }
        NSLog(@"db save data begin");
            
        NSString *userID = [self getUserID];
//    for(int i=0;i<[data count];i++){
        NSString *sql = [[NSString alloc]initWithFormat:@"INSERT INTO %@ VALUES ('%@', '%@')",tableName,userID,data];
    
        if( [_db executeUpdate:sql]){
//            NSLog(@"第%i条插入成功",i);
        }else{
            NSLog(@"插入失败");
        }
//    }
    //    FMResultSet *s = [db executeQuery:@"CREATE * FROM myTable"];
}
//查询数据数组
- (NSString *)queryData:(NSString *)tableName{
    
    if (![_db open]) {
        
        if([self creatDatabase]){
            NSLog(@"数据库打开成功");
        }
        else{
            NSLog(@"创建数据库失败,查询数据失败");
            return nil;
        }
    }
    
        if(![_db tableExists:tableName]){
            NSLog(@"table did not exist:%@",tableName);
//            return @"";
            return nil;
        }
        NSLog(@"db query data begin");
        NSString *userID = [self getUserID];
        NSString *sql = [[NSString alloc]initWithFormat:@"SELECT data FROM %@ WHERE user_id=%@",tableName,userID];
//        FMResultSet *s = [_db executeQuery:@"SELECT Data FROM ? WHERE user_id=%@",tableName,userID];
    FMResultSet *s = [_db executeQuery:sql];

    while ([s next]) {
        
//            NSLog(@"query result:%@",[s stringForColumnIndex:0]);
//        todo
        return [s stringForColumnIndex:0];
        }
    return nil;
}

#pragma mark 删除表
- (BOOL)removeTable:(NSString *)tableName{
    
    if (![_db open]) {
        
        if([self creatDatabase]){
            NSLog(@"数据库打开成功");
        }
        else{
            NSLog(@"创建数据库失败,删除数据失败");
            return false;
        }
    }
    
    if(![_db tableExists:tableName]){
        NSLog(@"table did not exist:%@",tableName);
        return false;
    }
    
//    NSString *userID = [self getUserID];
    
    NSString *sql = [[NSString alloc]initWithFormat:@"DROP TABLE %@",tableName];
    if( [_db executeStatements:sql]){
        NSLog(@"删除成功");
        return true;
    }else{
        NSLog(@"删除失败");
        return false;
    }
}
#pragma mark 更新表内容
- (void)updateData:(NSString *)tableName andData:(NSString *)data{
    
    if (![_db open]) {
        
        if([self creatDatabase]){
            NSLog(@"数据库打开成功");
        }
        else{
            NSLog(@"创建数据库失败,更新数据失败");
            return ;
        }
    }
    
    if(![_db tableExists:tableName]){
        NSLog(@"table did not exist:%@",tableName);
        if([self creatTable:tableName]){
            NSLog(@"table 创建成功");
        }
        else{
            NSLog(@"创建表失败，更新失败");
            return;
        }
    }

    NSString *userID = [self getUserID];
    
    NSString *sql = [[NSString alloc]initWithFormat:@"UPDATE %@ SET data = '%@' WHERE user_id=%@",tableName,data,userID];
    if( [_db executeStatements:sql]){
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }


}

#pragma mark 获取user_id
-(NSString*) getUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"user_id"];
}
@end
