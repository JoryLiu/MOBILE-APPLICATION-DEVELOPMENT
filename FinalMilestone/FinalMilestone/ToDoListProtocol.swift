//
//  ToDoListProtocol.swift
//  FinalMilestone
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/27.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

protocol toDoListProtocol {
    var indexOfSelectedItem: Int? { get }
    var selectedItem: toDoListItem? { get }
    
    func save(indexOfSelectedItem: Int?, selectedItem: toDoListItem?,
              description: String, hasADue: Bool, dueDate: Date?)
    func cancle(_ dvc: ViewController)
}
