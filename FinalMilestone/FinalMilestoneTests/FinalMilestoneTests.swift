//
//  FinalMilestoneTests.swift
//  FinalMilestoneTests
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/25.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import XCTest
@testable import FinalMilestone

class FinalMilestoneTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let example1 = toDoListItem(description: "Wash the dishes", isChecked: true)
        XCTAssertEqual(example1.description, "Wash the dishes")
        XCTAssertEqual(example1.hasADue, false)
        XCTAssertEqual(example1.isChecked, true)
        
        let temp = "2018-9-30"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateformatter.date(from: temp)
        let example2 = toDoListItem(description: "Wash the car", dueDate: newDate, isChecked: false, hasADue: true)
        XCTAssertEqual(example2.description, "Wash the car")
        XCTAssertEqual(example2.dueDate, newDate)
        XCTAssertEqual(example2.isChecked, false)
        XCTAssertEqual(example2.hasADue, true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
