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
            sqlite3_bind_int(insertStatement, 0, Int32(empId))
            
            sqlite3_bind_text(insertStatement,
                              1,
                              (empName as NSString).utf8String,
                              -1,
                              nil)
            
            sqlite3_bind_text(insertStatement,
                              2,
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
    
    func retriveEmployeeRecords() -> [Employee]{
        let selectQueryString = "SELECT * FROM EMPLOYEE;"
        var selectStatement : OpaquePointer? = nil
        var employees : [Employee] = []
        if sqlite3_prepare_v2(db,
                              selectQueryString,
                              -1,
                              &selectStatement,
                              nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW{
                let rEmpId = sqlite3_column_int(selectStatement, 0)
                
                let rEmpName = String(describing: String(cString: sqlite3_column_text(selectStatement, 1)))
                
                let rEmpCity = String(describing: String(cString: sqlite3_column_text(selectStatement, 2)))
                
                employees.append(Employee(empId: Int(rEmpId) ?? 1, empName: rEmpName ?? "ABC", empCity: rEmpCity ?? "Mumbai"))
                
               /* for eachEmp in employees{
                    print("The result of select query is :\(eachEmp.empId)--\(rEmpName)--\(rEmpCity)")
                }*/
            }
        }
            else {
            print("The select statement preparation failed")
        }
        sqlite3_finalize(selectStatement)
        return employees
    }
    
    func deleteEmpById(empId : Int){
        let deleteQueryString = "DELETE FROM EMPLOYEE where EmpId = ?;"
        var deleteStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,
                              deleteQueryString,
                              -1,
                              &deleteStatement,
                              nil) == SQLITE_OK{
            
            sqlite3_bind_int(deleteStatement, 1, Int32(empId))
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
                print("The record of Employee with \(empId) is deleted")
            } else {
                print("Record deletion failed")
            }
        } else{
            print("The statement preparation for delete statement failed")
        }
        sqlite3_finalize(deleteStatement)
    }
}
