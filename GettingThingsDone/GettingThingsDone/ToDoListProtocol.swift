//
//  ToDoListProtocol.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/5/1.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

protocol toDoListProtocol {
    var sectionOfSelectedItem: Int? { get }
    var indexOfSelectedItem: Int? { get }
    var selectedItem: ToDoItem? { get }
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [String], collaborators: [String])
}
