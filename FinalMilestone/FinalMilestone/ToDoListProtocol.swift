//
//  ToDoListProtocol.swift
//  FinalMilestone
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/27.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

/// Protocol for passing parameters from tableViewController to viewController
protocol toDoListProtocol {
    
    /// The index of selected item in the array (nil for none)
    var indexOfSelectedItem: Int? { get }
    
    /// The selected item object (nil for none)
    var selectedItem: toDoListItem? { get }
    
    /**
     Save what user creates or changes
     
     - Parameter indexOfSelectedItem: The index of selected item in the array (nil for none)
     - Parameter selectedItem: The selected item object (nil for none)
     - Parameter description: The description of a toDoListItem
     - Parameter hasADue: True for having a due date, false for not
     - Parameter dueDate: The dueDate (nil for none)
     */
    func save(indexOfSelectedItem: Int?, selectedItem: toDoListItem?,
              description: String, hasADue: Bool, dueDate: Date?)
}
