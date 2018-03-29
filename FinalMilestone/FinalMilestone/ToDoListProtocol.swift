//
//  ToDoListProtocol.swift
//  FinalMilestone
//
//  Created by 刘钊睿 on 2018/3/27.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import Foundation

protocol toDoListProtocol {
    var indexOfSelectedItem: Int? { get }
    var selectedItem: toDoListItem? { get }
    
    func save()
    func cancle(_ dvc: ViewController)
}
