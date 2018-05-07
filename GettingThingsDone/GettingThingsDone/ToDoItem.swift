//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

class Record {
    var time: NSDate
    var description: String
    var editable: Bool
    
    init(time: NSDate = NSDate(), description: String = "", editable: Bool = false) {
        self.time = time
        self.description = description
        self.editable = editable
    }
}

class ToDoItem {
    var task: String
    var history: [Record]
    var collaborators: [String]
    
    init(task: String, history: [Record] = [Record](),
         collaborators: [String] = [String]()) {
        self.task = task
        self.history = history
        self.collaborators = collaborators
    }
}
