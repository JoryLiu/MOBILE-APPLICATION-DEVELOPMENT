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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard indexOfSelectedItem != nil else {
            return
        }
        myTextField.text = selectedItem?.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}
