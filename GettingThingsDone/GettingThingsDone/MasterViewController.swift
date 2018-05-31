//
//  MasterViewController.swift
//  GettingThingsDone
//
//  Created by Zhaorui Liu on 4/5/18.
//  Copyright © 2018 Zhaorui Liu. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

/// View controller to control master view
class MasterViewController: UITableViewController, toDoListProtocol, PeerToPeerManagerDelegate {
    /// The P2P manager
    var peerToPeer = PeerToPeerManager()
    
    /// View controller to control detail view
    var detailViewController: DetailViewController? = nil
    
    /// Titles of sections
    let headers = ["YET TO DO", "COMPLETED"]
    /// An array for storing toDoListItem
    var myTasks = [[ToDoItem](), [ToDoItem]()]
    
    /// The section of selected item (nil for none)
    var sectionOfSelectedItem: Int?
    /// The index of selected item (nil for none)
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
        
        peerToPeer.delegate = self
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
            
            myTasks[j][i].history.insert(Record(description: peerToPeer.peerId.displayName + " deleted"), at: 0)
            syncWithCollaborators(item: myTasks[j][i])
            
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
            let completeRecod: Record = Record(description: peerToPeer.peerId.displayName + " completed")
            temp.history.insert(completeRecod, at: 0)
            temp.isFinished = true

            syncWithCollaborators(item: temp)
        } else if fromSection == 1 && toSection == 0 {
            let completeRecod: Record = Record(description: peerToPeer.peerId.displayName + " restarted")
            temp.history.insert(completeRecod, at: 0)
            temp.isFinished = false
            syncWithCollaborators(item: temp)
        }
        
        myTasks[fromSection].remove(at: fromRow)
        myTasks[toSection].insert(temp, at: toRow)
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.detailViewController?.tableView.reloadData()
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navi = segue.destination as! UINavigationController
        let dvc = navi.topViewController as! DetailViewController
        detailViewController = dvc
        
        dvc.navigationItem.leftItemsSupplementBackButton = true
        dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        dvc.delegator = self
        dvc.peers = peerToPeer.session.connectedPeers
        
        let cell = sender as! UITableViewCell
        let indexPath: IndexPath = tableView.indexPath(for: cell)!
        indexOfSelectedItem = indexPath.row
        sectionOfSelectedItem = indexPath.section
        if let i = sectionOfSelectedItem, let j = indexOfSelectedItem {
            dvc.sectionOfSelectedItem = i
            dvc.indexOfSelectedItem = indexOfSelectedItem
            dvc.selectedItem = myTasks[i][j]
            dvc.peers = peerToPeer.session.connectedPeers
            dvc.displayName = peerToPeer.peerId.displayName
        }
    }
    
    // MARK: - Protocl
    
    func save(sectionOfSelectedItem: Int?, indexOfSelectedItem: Int?, selectedItem: ToDoItem?,
              task: String, history: [Record], collaborators: [String]) {
        let fliteredHistory = history.filter {$0.description != ""}
        
        if selectedItem?.task != task {
            selectedItem?.task = task
       }
        selectedItem?.history = fliteredHistory
        selectedItem?.collaborators = collaborators
        tableView.reloadData()
        syncWithCollaborators(item: selectedItem!)
    }
    
    func manager(_ manager: PeerToPeerManager, didReceive data: Data) {
        let temp = json(data)
        for k in 0 ... temp.collaborators.count - 1 {
            if (temp.collaborators[k] == peerToPeer.peerId.displayName) {
                temp.collaborators.remove(at: k)
                temp.collaborators.insert(peerToPeer.peerId.displayName, at: 0)
            }
        }
        var flag = false
        
        for i in 0 ... 1 {
            if myTasks[i].isEmpty {
                continue
            }
            for j in 0 ... myTasks[i].count - 1 {
                if temp.id == myTasks[i][j].id {
                    if i == self.sectionOfSelectedItem && j == self.indexOfSelectedItem {
                        let latestHistoryRecord = temp.history[0].description
                        let latestHistoryRecordArr = latestHistoryRecord.split(separator: " ").map(String.init)
                        
                        if latestHistoryRecordArr.last == "deleted" {
                            temp.collaborators.remove(at: 1)
                        }
                        self.detailViewController?.text = temp.task
                        self.detailViewController?.selectedItem = temp
                        self.detailViewController?.historyRecords = temp.history
                        self.detailViewController?.collaborators = temp.collaborators
                    }
                    
                    if (temp.isFinished && i == 1) || (!temp.isFinished && i == 0) {
                        myTasks[i][j] = temp
                        flag = true
                    } else {
                        myTasks[i].remove(at: j)
                    }
                }
            }
        }
        if !flag {
            myTasks[temp.isFinished ? 1 : 0].insert(temp, at: 0)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.detailViewController?.tableView.reloadData()
        }
    }
    
    func updatePeers(_ manager: PeerToPeerManager) {
        detailViewController?.peers = peerToPeer.session.connectedPeers
        DispatchQueue.main.async {
            self.detailViewController?.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
    
    // MARK: - Data
    
    /**
     To encode data
     
     - Parameter item: The item needs to be encoded
     */
    func json(item: ToDoItem) -> Data {
        return try! JSONEncoder().encode(item)
    }
    
    /**
     To decode data
     
     - Parameter data: The data needs to be decoded
     */
    func json(_ data: Data)-> ToDoItem {
        return try! JSONDecoder().decode(ToDoItem.self, from: data)
    }
    
    /**
     To sychronize the changes with collaborators
     
     - Parameter item: The item needs to be sent
     */
    func syncWithCollaborators(item: ToDoItem) {
        var toPeers = [MCPeerID]()
        for peer in peerToPeer.session.connectedPeers {
            if item.collaborators.index(of: peer.displayName) != nil && item.collaborators.index(of: peer.displayName) != 0 {
                toPeers.append(peer)
            }
        }
        peerToPeer.send(data: json(item: item), toPeers: toPeers)
    }
    
    /**
     To add a new task
     
     - Parameter sender: The UI object sending this action
     */
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        let addRecord = Record(description: peerToPeer.peerId.displayName + " added")
        var records = [Record]()
        records.append(addRecord)
        var collaborators = [String]()
        collaborators.append(peerToPeer.peerId.displayName)
        myTasks[0].insert(ToDoItem(task: "Todo Item", history: records, collaborators: collaborators), at: 0)
        tableView.reloadData()
    }

}
