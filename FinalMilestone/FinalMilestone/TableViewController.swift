//
//  TableViewController.swift
//  FinalMilestone
//
//  Created by 刘钊睿(Zhaorui Liu s5121594) on 2018/3/25.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, toDoListProtocol {
    
    var toDoList = [toDoListItem]()
    
    var indexOfSelectedItem: Int?
    var selectedItem: toDoListItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem // To show edit button
        initialization()
    }
    
    func initialization() { // initialize with some examples
        toDoList.append(toDoListItem(description: "Buy Bread"))
        toDoList.append(toDoListItem(description: "Buy Milk", isChecked: true))
        toDoList.append(toDoListItem(description: "Buy Veggies"))
        let temp = "2018-3-29"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateformatter.date(from: temp)
        toDoList.append(toDoListItem(description: "Finish Assignment", dueDate: newDate, isChecked: false, hasADue: true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 // There's only one section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoList.count // Number of rows equals the number of items
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // Get the cell with identifier

        // Configure the cell...
        let i = indexPath.row // Get the index to position the corresponding item
        cell.textLabel?.text = toDoList[i].description; // To show the description
        if toDoList[i].hasADue { // If it has a due date, show it
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .short
            dateformatter.timeStyle = .none
            cell.detailTextLabel?.text = dateformatter.string(from: toDoList[i].dueDate!)
        } else {
            cell.detailTextLabel?.text = ""
        }
        cell.accessoryType = toDoList[i].isChecked ? .checkmark : .none // If it's checked, show it
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ViewController // Set the destination of the segue
        dvc.delegator = self
        if sender is UIBarButtonItem { // To make sure the sender is a UITableViewCell
            return
        }
        let cell = sender as! UITableViewCell
        let indexPath: IndexPath = tableView.indexPath(for: cell)!
        indexOfSelectedItem = indexPath.row
        if let i = indexOfSelectedItem { // Sotre infomation
            dvc.indexOfSelectedItem = i
            dvc.selectedItem = toDoList[i]
        }
    }
    
    func save(indexOfSelectedItem: Int?, selectedItem: toDoListItem?,
              description: String, hasADue: Bool, dueDate: Date?) {
        guard let i = indexOfSelectedItem else { // Create a new item
            toDoList.append(toDoListItem(description: description, dueDate: dueDate, isChecked: false, hasADue: hasADue))
            tableView.reloadData()
            return
        }
        // make some changes
        toDoList[i].description = description
        toDoList[i].hasADue = hasADue
        if hasADue {
            toDoList[i].dueDate = dueDate
        }
        tableView.reloadData()
    }
    
    func cancle(_ dvc: ViewController) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check or uncheck when hit
        let i = indexPath.row
        toDoList[i].isChecked = !(toDoList[i].isChecked)
        tableView.reloadData()
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
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let i = indexPath.row
            toDoList.remove(at: i)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // Change order: romove it from the previous position and then insert it to the target position
        let from = fromIndexPath.row
        let dest = to.row
        let temp = toDoList[from]
        toDoList.remove(at: from)
        toDoList.insert(temp, at: dest)
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
