//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    @IBOutlet weak var myTextField: UITextField!
}

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    let headers = ["TASK", "HISTORY", "COLLABORATORS"]
    
    var sectionOfSelectedItem: Int?
    var indexOfSelectedItem: Int?
    var selectedItem: ToDoItem?
    
    var delegator: toDoListProtocol?
    
    var text: String?
    var historyRecords = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem\
        if let t = selectedItem?.task {
            text = t
        }
        guard let item = selectedItem else {
            historyRecords.insert(Record(description: "added"), at: 0)
            return
        }
        
        historyRecords = item.history
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard text != "" else {
            return
        }
        
        if let t = text {
            delegator?.save(sectionOfSelectedItem: sectionOfSelectedItem, indexOfSelectedItem: indexOfSelectedItem, selectedItem: selectedItem, task: t, history: historyRecords, collaborators: [String]())
        }
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
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCell
        
        // Configure the cell..
        var offSet: CGFloat = 0
        if indexPath.section == 0 {
            cell.myTextField.text = selectedItem?.task
        } else if indexPath.section == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy, HH:mm a"
            cell.textLabel?.text = dateFormatter.string(from: historyRecords[indexPath.row].time as! Date)
            
            cell.myTextField.layer.position = CGPoint(x: 500, y: 0)
            offSet = 150
            
            cell.myTextField.text = historyRecords[indexPath.row].description
            cell.myTextField.isEnabled = historyRecords[indexPath.row].editable
        }
        
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
        } else if indexPath?.section == 1 {
            historyRecords[0].description = textField.text!
        }
        return true
    }
    
    @IBAction func addhistory(_ sender: UIBarButtonItem) {
        historyRecords.insert(Record(editable: true), at: 0)
        tableView.reloadData()
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

