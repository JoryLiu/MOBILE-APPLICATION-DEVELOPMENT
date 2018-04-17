//
//  ListItem.swift
//  FinalMilestone
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/25.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

class toDoListItem {
    var description: String
    var dueDate: Date?
    var isChecked: Bool
    var hasADue: Bool
    
    init(description: String, dueDate: Date? = nil,
         isChecked: Bool = false, hasADue: Bool = false) {
        self.description = description
        self.dueDate = dueDate
        self.isChecked = isChecked
        self.hasADue = hasADue
    }
}
