//
//  Employee.swift
//  03_10_2022_SqliteDemo
//
//  Created by Vishal Jagtap on 05/12/22.
//

import Foundation
class Employee{
    var empId : Int
    var empName : String
    var empCity : String
    
    init(empId: Int, empName: String, empCity : String) {
        self.empId = empId
        self.empName = empName
        self.empCity = empCity
    }
}

//var emp1 = Employee(empId: 10, empName: "ABC", empCity: "XYZ")
