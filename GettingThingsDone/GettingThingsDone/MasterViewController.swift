//
//  MasterViewController.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/4/24.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, toDoListProtocol {
    
    let headers = ["YET TO DO", "COMPLETED"]
    var myTasks = [[ToDoItem](), [ToDoItem]()]
    
    var sectionOfSelectedItem: Int?
    var indexOfSelectedItem: Int?
    var selectedItem: ToDoItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        initialization()
    }
    
    func initialization() {
        myTasks[0].append(ToDoItem(task: "Todo Item 1"))
        myTasks[0].append(ToDoItem(task: "Todo Item 2"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myTasks[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let i = indexPath.row
        let j = indexPath.section
        cell.textLabel?.text = myTasks[j][i].task
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! DetailViewController
        dvc.delegator = self
        
        if sender is UIBarButtonItem {
            return
        }
        
        let cell = sender as! UITableViewCell
        let indexPath: IndexPath = tableView.indexPath(for: cell)!
        indexOfSelectedItem = indexPath.row
        sectionOfSelectedItem = indexPath.section
        if let i = sectionOfSelectedItem {
            dvc.sectionOfSelectedItem = i
            dvc.indexOfSelectedItem = indexOfSelectedItem
            dvc.selectedItem = myTasks[i][indexOfSelectedItem!]
        }
    }
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [String], collaborators: [String]) {
        guard sectionOfSelectedItem == 0 else {
            myTasks[0].append(ToDoItem(task: task))
            tableView.reloadData()
            return
        }
        
        myTasks[0][indexOfSelectedItem!].task = task
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let i = indexPath.row
            let j = indexPath.section
            myTasks[j].remove(at: i)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromSection = fromIndexPath.section
        let fromRow = fromIndexPath.row
        let toSection = to.section
        let toRow = to.row
        let temp = myTasks[fromSection][fromRow]
        
        myTasks[fromSection].remove(at: fromRow)
        myTasks[toSection].insert(temp, at: toRow)
        tableView.reloadData()
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
