//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

/// History record definition
class Record:Codable {
    /// Log time
    var time: Date
    /// Description of log
    var description: String
    /// Can this log be edited
    var editable: Bool
    
    /**
     This function performs the initialisation
     
     - Parameter time: Log time
     - Parameter description: Description of log
     - Parameter editable: Can this log be edited
     */
    init(time: Date = Date(), description: String = "", editable: Bool = false) {
        self.time = time
        self.description = description
        self.editable = editable
    }
}

/// Model for an item in the toDoList
class ToDoItem: Codable {
    /// To describ what is to be done
    var task: String
    /// Log records
    var history: [Record]
    /// The array of collaborators' displayName
    var collaborators: [String]
    /// Identity of an item
    let id: String
    /// To indicate this item is finished or not
    var isFinished: Bool
    
    /**
     This function performs the initialisation
     
     - Parameter task: To describ what is to be done
     - Parameter history: Log records
     - Parameter collaborators: The array of collaborators' displayName
     - Parameter id: Identity of an item
     - Parameter isFinished: To indicate this item is finished or not
     */
    init(task: String, history: [Record] = [Record](),
         collaborators: [String] = [String](), id: String = UUID().uuidString, isFinished: Bool = false) {
        self.task = task
        self.history = history
        self.collaborators = collaborators
        self.id = id
        self.isFinished = isFinished
    }
}
