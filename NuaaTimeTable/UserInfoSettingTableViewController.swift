//
//  UserInfoSettingTableViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class UserInfoSettingTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var delegate : LoginDelegate? = nil
    @IBOutlet weak var xhTextField : UITextField!
    @IBOutlet weak var pwdTextField : UITextField!
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        println(self.xhTextField.text)
        println(self.pwdTextField.text)
    }
    
    //PickerView
    let xnArray = ["2013-2014","2014-2015","2015-2016","2016-2017"]
    let xqArray = ["1","2"]
    var xn = String()
    var xq = String()
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? xnArray.count : xqArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return component == 0 ? xnArray[row] : xqArray[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("row:\(row) component:\(component)")
        if(component == 0){
            xn = xnArray[row]
        }
        else{
            xq = xqArray[row]
        }
    }

}
