//
//  GettingThingsDoneTests.swift
//  GettingThingsDoneTests
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import XCTest
@testable import GettingThingsDone

class GettingThingsDoneTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecord() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let example1 = Record(description: "added")
        XCTAssertEqual(example1.description, "added")
        XCTAssertEqual(example1.editable, false)
        
        let temp = "2018-9-30"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateformatter.date(from: temp)
        let example2 = Record(time: newDate!, description: "working on it", editable: true)
        XCTAssertEqual(example2.description, "working on it")
        XCTAssertEqual(example2.editable, true)
        XCTAssertEqual(example2.time, newDate)
    }
    
    func testTodoItem() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let example1 = ToDoItem(task: "Wash dishes")
        XCTAssertEqual(example1.task, "Wash dishes")
        XCTAssertEqual(example1.isFinished, false)
        
        let exampleRecord1 = Record(description: "added")
        let exampleRecord2 = Record(description: "completed")
        let exampleID = UUID().uuidString
        let example2 = ToDoItem(task: "Finish assignments", history: [exampleRecord1, exampleRecord2], collaborators: ["Tom", "Jack", "Alice"], id: exampleID, isFinished: true)
        XCTAssertEqual(example2.task, "Finish assignments")
        XCTAssertEqual(example2.history.count, 2)
        XCTAssertEqual(example2.history[0].description, exampleRecord1.description)
        XCTAssertEqual(example2.history[1].description, exampleRecord2.description)
        XCTAssertEqual(example2.collaborators.count, 3)
        XCTAssertEqual(example2.collaborators[0], "Tom")
        XCTAssertEqual(example2.collaborators[1], "Jack")
        XCTAssertEqual(example2.collaborators[2], "Alice")
        XCTAssertEqual(example2.id, exampleID)
        XCTAssertEqual(example2.isFinished, true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
