//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class MyCell: UITableViewCell {
    @IBOutlet weak var myTextField: UITextField!
}

class DetailViewController: UITableViewController, UITextFieldDelegate {
    let headers = ["TASK", "HISTORY", "COLLABORATORS", "PEERS"]
    
    var sectionOfSelectedItem: Int?
    var indexOfSelectedItem: Int?
    var selectedItem: ToDoItem?
    
    var delegator: toDoListProtocol?
    
    var text: String?
//    var historyRecords = [Record]()
//    var collaberators = [String]()
    var peers: [MCPeerID]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let t = selectedItem?.task {
            text = t
        }
        
//        let notificationName = Notification.Name(rawValue: "SelectedItem Completed")
//        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
//            self.historyRecords.insert(Record(description: "completed"), at: 0)
//            //self.tableView.reloadData()
//            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
//        }
        
//        guard let item = selectedItem else {
//            return
//        }
        
//        historyRecords = item.history
//        collaberators = item.collaborators
    }
    
    func saveChanges() {
        guard text != "" else {
            return
        }
        
        if let t = text {
            delegator?.save(sectionOfSelectedItem: sectionOfSelectedItem, indexOfSelectedItem: indexOfSelectedItem, selectedItem: selectedItem, task: t, history: historyRecords, collaborators: collaberators)
        }
        //tableView.reloadData()
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
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
        if section == 0 {
            return 1
        } else if section == 1 {
            return historyRecords.count
        } else if section == 2 {
            return collaberators.count - 1
        } else {
            guard let p = peers else {
                return 0
            }
            return p.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MyCell!
        // Configure the cell..
        var offSet: CGFloat = 0
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! MyCell

            cell.myTextField.text = selectedItem?.task
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! MyCell

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy, HH:mm a"
            cell.textLabel?.text = dateFormatter.string(from: historyRecords[indexPath.row].time)
            
            cell.myTextField.layer.position = CGPoint(x: 500, y: 0)
            offSet = 150
            
            cell.myTextField.text = historyRecords[indexPath.row].description
            cell.myTextField.isEnabled = historyRecords[indexPath.row].editable
            
            let leadingConstraint = NSLayoutConstraint(
                item: cell.myTextField,
                attribute: NSLayoutAttribute.leading,
                relatedBy: .equal,
                toItem: cell.contentView,
                attribute: .leadingMargin,
                multiplier: 1.0,
                constant: offSet
            )
            cell.contentView.addConstraint(leadingConstraint)
            
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "peerCell", for: indexPath) as! MyCell

            cell.textLabel?.text = collaberators[indexPath.row + 1]
        } else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "peerCell", for: indexPath) as! MyCell
            cell.textLabel?.text = peers![indexPath.row].displayName
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let cell: UITableViewCell = textField.superview!.superview as! UITableViewCell
        let table: UITableView = cell.superview as! UITableView
        let indexPath = table.indexPath(for: cell)
        
        if indexPath?.section == 0 {
            text = textField.text
            if let t = text, let item = selectedItem, t != item.task && t != "" {
                let renameRecord:Record = Record(description: "changed to \(t)")
                historyRecords.insert(renameRecord, at: 0)
            }
        } else if indexPath?.section == 1 {
            historyRecords[(indexPath?.row)!].description = textField.text!
        }
        saveChanges()
        return true
    }
    
    @IBAction func addhistory(_ sender: UIBarButtonItem) {
        historyRecords.insert(Record(editable: true), at: 0)
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
        let text = cell.textLabel?.text
        
        if indexPath.section == 3 && collaberators.index(of: text!) == nil {
            collaberators.insert(peers![indexPath.row].displayName, at: 1)
            self.tableView.reloadData()
            saveChanges()
        }
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

