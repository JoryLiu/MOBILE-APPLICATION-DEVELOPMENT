//
//  ViewController.swift
//  FinalMilestone
//
//  Created by 刘钊睿 on 2018/3/27.
//  Copyright © 2018年 Griffith University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    var indexOfSelectedItem: Int?
    var selectedItem: toDoListItem?
    
    private var isCanceled: Bool = false
    var delegator: toDoListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.minimumDate = Date()

        // Do any additional setup after loading the view.
        guard indexOfSelectedItem != nil else {
            mySwitch.isOn = false
            myDatePicker.isEnabled = false
            return
        }
        myTextField.text = selectedItem?.description
        if (selectedItem?.hasADue)! {
            mySwitch.isOn = true
            myDatePicker.date = (selectedItem?.dueDate)!
        } else {
            mySwitch.isOn = false
            myDatePicker.isEnabled = false
        }
        isCanceled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isCanceled {
            guard myTextField.text != "" else {
                return
            }
            delegator?.save(indexOfSelectedItem: indexOfSelectedItem, selectedItem: selectedItem,
                            description: myTextField.text!, hasADue: mySwitch.isOn, dueDate: myDatePicker.date)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    @IBAction func enableOrDisableDue(_ sender: UISwitch) {
        myDatePicker.isEnabled = mySwitch.isOn ? true : false
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        isCanceled = true
        self.navigationController?.popViewController(animated: true)
    }
    
}
