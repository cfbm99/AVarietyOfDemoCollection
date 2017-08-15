

//
//  CFDataBase.swift
//  hqlsCloudPlatform
//
//  Created by Apple on 2017/6/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SQLite

struct CFDataBase {
    
    fileprivate var db: Connection?
    fileprivate let cacheTable = Table("cacheTable")
    fileprivate let id = Expression<Int>("id")
    fileprivate let keyname = Expression<String>("keyname")
    fileprivate let cacheTime = Expression<String>("cacheTime")
    fileprivate let cahceData = Expression<Data>("cahceData")
    
    fileprivate var currentDate: String {
        let date = Date()
        return date.convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    init(filePath: String) {
        creatSQLite3Table(filePath: filePath)
    }
    
    mutating func creatSQLite3Table(filePath: String) {
        guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last else { return }
        let sqliteFilePath = path + "/\(filePath)DB.sqlite"
        print(sqliteFilePath)
        db = try? Connection(sqliteFilePath)
        do {
            try db?.run(cacheTable.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(keyname)
                t.column(cacheTime)
                t.column(cahceData)
            }))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func insertData(name: String, data: Data?) {
        guard let data = data else { return }
        let query = cacheTable.filter(keyname == name).limit(1)
        do {
            if let filter = try db?.prepare(query) {
                if filter.makeIterator().next() == nil {
                    let insert = cacheTable.insert(keyname <- name, cacheTime <- currentDate, cahceData <- data)
                    do {
                        try db?.run(insert)
                        print("save success")
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    do {
                        try db?.run(query.update(cacheTime <- currentDate, cahceData <- data))
                    } catch  {
                        print(error.localizedDescription)
                    }
                }
            }
        } catch  {
            print(error.localizedDescription)
        }

    }
    
    public func getItem(name: String) -> DataBaseItem? {
        do {
            if let filter = try db?.prepare(cacheTable.filter(keyname == name).limit(1)) {
                for v in filter {
                    return DataBaseItem(name: v.get(keyname), date: v.get(cacheTime), data: v.get(cahceData))
                }
            }
        } catch  {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }
    
    public func deleteData(name: String) {
        do {
            try db?.run(cacheTable.filter(keyname == name).limit(1).delete())
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}


struct DataBaseItem {
    var name: String
    var date: String
    var data: Data
    
}
