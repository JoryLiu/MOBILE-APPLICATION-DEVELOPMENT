//
//  MasterViewController.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import UIKit
import Foundation

class MasterViewController: UITableViewController, toDoListProtocol {
    
    var detailViewController: DetailViewController? = nil
    
    let headers = ["YET TO DO", "COMPLETED"]
    var myTasks = [[ToDoItem](), [ToDoItem]()]
    
    var sectionOfSelectedItem: Int?
    var indexOfSelectedItem: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        initialization()
    }
    
    func initialization() {
        let addRecord = Record(description: "added")
        var records = [Record]()
        records.append(addRecord)
        myTasks[0].append(ToDoItem(task: "Todo Item 1", history: records))
        myTasks[0].append(ToDoItem(task: "Todo Item 2", history: records))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
        
        if fromSection == 0 && toSection == 1 {
            let completeRecod: Record = Record(description: "completed")
            temp.history.insert(completeRecod, at: 0)
            
            if let row = indexOfSelectedItem, let section = sectionOfSelectedItem {
                if row == fromRow && section == fromSection {
                    let notificationName = Notification.Name(rawValue: "SelectedItem Completed")
                    NotificationCenter.default.post(name: notificationName, object: self)
                }
            }
        }
        
        myTasks[fromSection].remove(at: fromRow)
        myTasks[toSection].insert(temp, at: toRow)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navi = segue.destination as! UINavigationController
        let dvc = navi.topViewController as! DetailViewController
        dvc.navigationItem.leftItemsSupplementBackButton = true
        dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        dvc.delegator = self
        
        if segue.identifier == "showDetail" {
            
            let cell = sender as! UITableViewCell
            let indexPath: IndexPath = tableView.indexPath(for: cell)!
            indexOfSelectedItem = indexPath.row
            sectionOfSelectedItem = indexPath.section
            if let i = sectionOfSelectedItem, let j = indexOfSelectedItem {
                dvc.sectionOfSelectedItem = i
                dvc.indexOfSelectedItem = indexOfSelectedItem
                dvc.selectedItem = myTasks[i][j]
            }
        }
        
    }
    
    // MARK: - Protocl
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [Record], collaborators: [String]) {
        let fliteredHistory = history.filter {$0.description != ""}
        guard sectionOfSelectedItem != nil else {
            myTasks[0].insert(ToDoItem(task: task, history: fliteredHistory), at: 0)
            tableView.reloadData()
            return
        }
        
        if selectedItem?.task != task {
//            let renameRecord:Record = Record(description: "changed to \(task)")
//            fliteredHistory.insert(renameRecord, at: 0)
//            //            myTasks[s][indexOfSelectedItem!].task = task
            selectedItem?.task = task
       }
        selectedItem?.history = fliteredHistory
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
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

/*
class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}
*/
