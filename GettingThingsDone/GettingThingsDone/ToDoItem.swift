//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/4/24.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

class ToDoItem {
    var task: String
    var history: [String]
    var collaborators: [String]
    
    init(task: String, history: [String], collaborators: [String]) {
        self.task = task
        self.history = history
        self.collaborators = collaborators
    }
}
