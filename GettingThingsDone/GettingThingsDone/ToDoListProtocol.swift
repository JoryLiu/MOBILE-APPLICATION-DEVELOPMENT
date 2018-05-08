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
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [Record], collaborators: [String])
}
