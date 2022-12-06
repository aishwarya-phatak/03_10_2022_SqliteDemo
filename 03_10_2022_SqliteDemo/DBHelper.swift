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
        createTable()
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
        
       // var db : OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_FAIL{
            print("Error in Database Creation")
            return nil
        } else {
            print("Database created Successfully \(dbPath)")
            print("Database is : \(db)")
            return db
        }
    }
    
    func createTable(){
        let createQueryString = "CREATE TABLE IF NOT EXISTS EMPLOYEE(EmpId INTEGER PRIMARY KEY, EmpName TEXT, EmpCity TEXT);"
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,
                              createQueryString,
                              -1,
                              &createTableStatement,
                              nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Employee Table is created")
            } else {
                print("Employee Table creation failed")
            }
        } else{
            print("Preparing the Create Table Statement has failed")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertEmployeeRecordsIntoEmployeeTable(empId : Int, empName : String, empCity : String){
        let insertQueryString = "INSERT INTO EMPLOYEE(EmpId,EmpName,EmpCity) VALUES(?,?,?);"
        var insertStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,
                              insertQueryString,
                              -1,
                              &insertStatement,
                              nil) == SQLITE_OK{
            sqlite3_bind_int(insertStatement, 1, Int32(empId))
            
            sqlite3_bind_text(insertStatement,
                              2,
                              (empName as NSString).utf8String,
                              -1,
                              nil)
            
            sqlite3_bind_text(insertStatement,
                              3,
                              (empCity as NSString).utf8String,
                              -1,
                              nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Row instered successfully")
            } else {
                print("Row insertion failed")
            }
        } else{
            print("Statement could not be prepared")
        }
        sqlite3_finalize(insertStatement)
    }
}
