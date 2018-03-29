//
//  ListItem.swift
//  FinalMilestone
//
//  Created by 刘钊睿 on 2018/3/25.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

class toDoListItem {
    var description: String
    var dueDate: Date?
    var beChecked: Bool
    var hasADue: Bool
    
    init(description: String, dueDate: Date? = nil,
         beChecked: Bool = false, hasADue: Bool = false) {
        self.description = description
        self.dueDate = dueDate
        self.beChecked = beChecked
        self.hasADue = hasADue
    }
}
