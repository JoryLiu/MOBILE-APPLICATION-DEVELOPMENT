//
//  TableViewController.swift
//  FinalMilestone
//
//  Created by 刘钊睿 on 2018/3/25.
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
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        initialization()
    }
    
    func initialization() {
        toDoList.append(toDoListItem(description: "Buy Bread"))
        toDoList.append(toDoListItem(description: "Buy Milk", beChecked: true))
        toDoList.append(toDoListItem(description: "Buy Veggies"))
        let temp = "2018-3-29"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateformatter.date(from: temp)
        toDoList.append(toDoListItem(description: "Finish Assignment", dueDate: newDate, beChecked: false, hasADue: true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let i = indexPath.row
        cell.textLabel?.text = toDoList[i].description;
        if toDoList[i].hasADue {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .short
            dateformatter.timeStyle = .none
            cell.detailTextLabel?.text = dateformatter.string(from: toDoList[i].dueDate!)
        } else {
            cell.detailTextLabel?.text = ""
        }
        cell.accessoryType = toDoList[i].beChecked ? .checkmark : .none
        //cell.textLabel?.text = toDoList[i]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ViewController
        let cell = sender as! UITableViewCell
        let indexPath :IndexPath = tableView.indexPath(for: cell)!
        indexOfSelectedItem = indexPath.row
        if let i = indexOfSelectedItem {
            dvc.indexOfSelectedItem = i
            dvc.selectedItem = toDoList[i]
        }
    }
    
    func save() {
        
    }
    
    func cancle(_ dvc: ViewController) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
