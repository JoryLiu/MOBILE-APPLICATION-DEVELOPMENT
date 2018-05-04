//
//  ToDoListProtocol.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

protocol toDoListProtocol {
    var sectionOfSelectedItem: Int? { get }
    var indexOfSelectedItem: Int? { get }
    var selectedItem: ToDoItem? { get }
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [String], collaborators: [String])
}
