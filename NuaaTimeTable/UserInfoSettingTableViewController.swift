//
//  UserInfoSettingTableViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class UserInfoSettingTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var xhTextField : UITextField!
    @IBOutlet weak var pwdTextField : UITextField!
    @IBOutlet weak var xnxqPickerView: UIPickerView!
    @IBOutlet weak var setDateManually: UISwitch!
    @IBOutlet weak var semesterDatePicker: UIDatePicker!
    
    var engine = DedEngine.sharedInstance
    var delegate : LoginDelegate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.xnxqPickerView.selectRow(1, inComponent: 0, animated: true)
        self.xnxqPickerView.selectRow(0, inComponent: 1, animated: true)
        self.setDateManually.setOn(false, animated: true)
        self.xn = self.xnArray[1]
        self.xq = self.xqArray[0]
    }
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        var userInfo = DEDUserInfo()
        userInfo <== [
            "xh"  : self.xhTextField.text,
            "pwd" : self.pwdTextField.text,
            "xn"  : self.xn,
            "xq"  : self.xq,
            "setSemesterDateManually" : self.setDateManually.on,
            "semesterDate" : self.semesterDatePicker.date
        ]
        self.engine.userInfo = userInfo
    }
    
    //PickerView
    let xnArray = ["2013-2014","2014-2015","2015-2016","2016-2017"]
    let xqArray = ["1","2"]
    var xn = "hehe"
    var xq = "haha"
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
