//
//  ListItem.swift
//  FinalMilestone
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/25.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

/// Model for an item in the toDoList
class toDoListItem {
    /// To describ what is to be done
    var description: String
    
    /// The dueDate (nil for none)
    var dueDate: Date?
    
    /// To mark if it is done
    var isChecked: Bool
    
    /// True for having a due date, false for not
    var hasADue: Bool
    
    /**
     This function performs the initialisation.
     
     - Parameter description: The description of a toDoListItem
     - Parameter dueDate: The dueDate (nil for none)
     - Parameter isChecked: To mark if it is done
     - Parameter hasADue: True for having a due date, false for not
     */
    init(description: String, dueDate: Date? = nil,
         isChecked: Bool = false, hasADue: Bool = false) {
        self.description = description
        self.dueDate = dueDate
        self.isChecked = isChecked
        self.hasADue = hasADue
    }
}
