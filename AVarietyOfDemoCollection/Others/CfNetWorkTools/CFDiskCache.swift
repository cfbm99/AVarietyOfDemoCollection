//
//  CFDiskCache.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/28.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

struct CFDiskCache {
    
    var db: OpaquePointer?
    
    init(path: String) {
        if !openSQLiteDataBase(path: path) || !creatTable() {
            print("sqlite open fail || creat table fail")
        }
    }
    
    mutating func openSQLiteDataBase(path: String) -> Bool {
        if let _ = db {
            return true
        }
        guard let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask, true).last else { return false }
        let finalPath = basePath + "/\(path)"
        print(finalPath)
        let cStr = finalPath.cString(using: .utf8)
        return sqlite3_open(cStr, &db) == SQLITE_OK
    }
    
    func creatTable() -> Bool {
        let creatTb = "create table if not exists netWorkCache (key text, size integer, inline_data blob,primary key(key));"
        return execSQL(SQL:creatTb)
    }
    
    func insertDataToDist(key: String, size: Int, data: Data) -> Bool {
        let insetSql = "insert or replace into netWorkCache (key, size, inline_data) values (?1, ?2, ?3)"
        guard let stmt = dbPrepareStmt(sql: insetSql) else { return false }
        let nsdata = data as NSData
        let nskey = key as NSString
        sqlite3_bind_text(stmt, 1, nskey.utf8String, -1, nil)
        sqlite3_bind_int(stmt, 2, Int32(size))
        sqlite3_bind_blob(stmt, 3, nsdata.bytes, Int32(nsdata.length), nil)
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func getDbItem(key: String) -> NetCacheModel? {
        let searchSql = "select key, size, inline_data from netWorkCache where key = ?1"
        guard let stmt = dbPrepareStmt(sql: searchSql) else { return nil }
        let nskey = key as NSString
        sqlite3_bind_text(stmt, 1, nskey.utf8String, -1, nil)
        if sqlite3_step(stmt) == SQLITE_ROW {
           return dbGetItemFormStmt(stmt: stmt)
        }else {
            return nil
        }
    }
    
    func dbPrepareStmt(sql: String?) -> OpaquePointer? {
        guard let sqlStr = sql else { return nil }
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlStr.cString(using: .utf8), -1, &stmt, nil) == SQLITE_OK {
            return stmt
        }else {
            return nil
        }
    }
    
    func dbGetItemFormStmt(stmt:OpaquePointer) -> NetCacheModel? {
        let size = sqlite3_column_int(stmt, 1)
        let databytes = sqlite3_column_bytes(stmt, 2)
        guard let key = sqlite3_column_text(stmt, 0),
        let data = sqlite3_column_blob(stmt, 2) else { return nil }
        let result = Data.init(bytes: data, count: Int(databytes))
        return NetCacheModel(key: String.init(cString: key), size: Int(size), data: result)
    }
    
    func execSQL(SQL: String?) -> Bool {
        guard let sqlstr = SQL else { return false }
        let cSQL = sqlstr.cString(using: .utf8)
        let error :UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        let result = sqlite3_exec(db, cSQL, nil, nil, error)
        if let err = error {
            print("sqlite exec error \(result),\(err)")
        }
        return result == SQLITE_OK
    }

}

struct NetCacheModel {
    var key: String!
    var size: Int!
    var data: Data!
}
