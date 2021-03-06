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

/// The custom tableView cell
class MyCell: UITableViewCell {
    /// The outlet of the textField in the cell
    @IBOutlet weak var myTextField: UITextField!
}

/// View controller to control detail view
class DetailViewController: UITableViewController, UITextFieldDelegate {
    /// Titles of sections
    let headers = ["TASK", "HISTORY", "COLLABORATORS", "PEERS"]
    /// The displayName of this device
    var displayName: String?
    
    /// The section of selected item (nil for none)
    var sectionOfSelectedItem: Int?
    /// The index of selected item (nil for none)
    var indexOfSelectedItem: Int?
    /// The selected item object (nil for none)
    var selectedItem: ToDoItem?
    
    /// Use protocol to pass parameters from TableViewController to ViewController
    var delegator: toDoListProtocol?
    
    /// The text in the textfield
    var text: String?
    /// The history records of selected item
    var historyRecords = [Record]()
    /// The array storing displayNames of collaborators
    var collaborators = [String]()
    /// The array storing peers' identities of potential peers
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
        
        guard let item = selectedItem else {
            return
        }
        
        historyRecords = item.history
        collaborators = item.collaborators
    }
    
    /// To save changes made on the selected item
    func saveChanges() {
        guard text != "" else {
            return
        }
        
        if let t = text {
            delegator?.save(sectionOfSelectedItem: sectionOfSelectedItem, indexOfSelectedItem: indexOfSelectedItem, selectedItem: selectedItem, task: t, history: historyRecords, collaborators: collaborators)
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
            return collaborators.count - 1
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

            cell.textLabel?.text = collaborators[indexPath.row + 1]
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
                let renameRecord:Record = Record(description: displayName! + " changed to \(t)")
                historyRecords.insert(renameRecord, at: 0)
            }
        } else if indexPath?.section == 1 {
            historyRecords[(indexPath?.row)!].description = textField.text!
        }
        saveChanges()
        return true
    }
    
    /**
     To add a new history record
     
     - Parameter sender: The UI object sending this action
     */
    @IBAction func addhistory(_ sender: UIBarButtonItem) {
        historyRecords.insert(Record(editable: true), at: 0)
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
        let text = cell.textLabel?.text
        
        if indexPath.section == 3 && collaborators.index(of: text!) == nil {
            collaborators.insert(peers![indexPath.row].displayName, at: 1)
            self.tableView.reloadData()
            saveChanges()
        }
    }
    
}

