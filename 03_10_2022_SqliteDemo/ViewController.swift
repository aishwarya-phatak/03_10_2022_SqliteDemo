//
//  ViewController.swift
//  03_10_2022_SqliteDemo
//
//  Created by Vishal Jagtap on 05/12/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dbHelper = DBHelper()
        dbHelper.insertEmployeeRecordsIntoEmployeeTable(empId: 10, empName: "Sachin", empCity: "Pune")
        dbHelper.insertEmployeeRecordsIntoEmployeeTable(empId: 11, empName: "Sachin", empCity: "Pune")
        
    }
}
