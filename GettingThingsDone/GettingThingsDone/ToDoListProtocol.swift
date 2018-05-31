//
//  ToDoListProtocol.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import Foundation

/// Protocol for passing parameters from tableViewController to viewController
protocol toDoListProtocol {
    /// The index of selected item in the array (nil for none)
    var sectionOfSelectedItem: Int? { get }
    /// The selected item object (nil for none)
    var indexOfSelectedItem: Int? { get }
    
    /**
     Save what user creates or changes
     
     - Parameter sectionOfSelectedItem: The section of selected item in the tableView (nil for none)
     - Parameter indexOfSelectedItem: The index of selected item in the tableView (nil for none)
     - Parameter selectedItem: The selected item object (nil for none)
     - Parameter task: The description of a toDoItem
     - Parameter history: The log of selected item
     - Parameter collaborators: The array of collaborators' displayName
     */
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [Record], collaborators: [String])
}
