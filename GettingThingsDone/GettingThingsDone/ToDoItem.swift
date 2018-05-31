//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

class Record:Codable {
    var time: Date
    var description: String
    var editable: Bool
    
    init(time: Date = Date(), description: String = "", editable: Bool = false) {
        self.time = time
        self.description = description
        self.editable = editable
    }
}

class ToDoItem: Codable {
    var task: String
    var history: [Record]
    var collaborators: [String]
    let id: String
    var isFinished: Bool
    
    init(task: String, history: [Record] = [Record](),
         collaborators: [String] = [String](), id: String = UUID().uuidString, isFinished: Bool = false) {
        self.task = task
        self.history = history
        self.collaborators = collaborators
        self.id = id
        self.isFinished = isFinished
    }
}
