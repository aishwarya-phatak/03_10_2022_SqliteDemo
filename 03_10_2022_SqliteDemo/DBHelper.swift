//
//  DBHelper.swift
//  03_10_2022_SqliteDemo
//
//  Created by Vishal Jagtap on 05/12/22.
//

import Foundation
import SQLite3

class DBHelper{
    
    init(){
        db = openDatabase()
       // createTable()
    }
    
    var dbPath : String = "my_database.sqlite"
    var db : OpaquePointer?
    
    func openDatabase() -> OpaquePointer?{
        let fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent(dbPath)
        
        print("File URL -- \(fileURL.path)")
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_FAIL{
            print("Error in Database Creation")
            return nil
        } else {
            print("Database created Successfully \(dbPath)")
            print("Database is : \(db)")
            return db
        }
    }
}
