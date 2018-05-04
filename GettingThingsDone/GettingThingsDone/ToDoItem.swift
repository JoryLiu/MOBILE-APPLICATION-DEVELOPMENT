//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

class ToDoItem {
    var task: String
    var history: [String]
    var collaborators: [String]
    
    init(task: String, history: [String] = [String](),
         collaborators: [String] = [String]()) {
        self.task = task
        self.history = history
        self.collaborators = collaborators
    }
}
