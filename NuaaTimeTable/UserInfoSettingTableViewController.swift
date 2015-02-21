//
//  UserInfoSettingTableViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit
import Dollar

class UserInfoSettingTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var xhTextField : UITextField!
    @IBOutlet weak var pwdTextField : UITextField!
    @IBOutlet weak var xnxqPickerView: UIPickerView!
    @IBOutlet weak var setDateManually: UISwitch!
    @IBOutlet weak var semesterDatePicker: UIDatePicker!
    
    var engine = DedEngine.sharedInstance
    var delegate : LoginDelegate? = nil
    
    func setupUI(){
        var xnIdx = 1, xqIdx = 0, switchValue = false;
        if let user = self.engine.userInfo {
            self.xhTextField.text = user.xh
            switchValue = user.setSemesterDateManually
            xnIdx = $.indexOf(self.xnArray,value: user.xn)!
            xqIdx = $.indexOf(self.xqArray,value: user.xq)!
            self.semesterDatePicker.setDate(self.engine.calculateFirstSemesterMonday(), animated: true)
        }
        else if let xh = NSUserDefaults.standardUserDefaults().stringForKey("xh_preference") {
            self.xhTextField.text = xh
        }
        self.xnxqPickerView.selectRow(xnIdx, inComponent: 0, animated: true)
        self.xnxqPickerView.selectRow(xqIdx, inComponent: 1, animated: true)
        self.setDateManually.setOn(switchValue, animated: true)
        if switchValue {
            self.semesterDatePicker.setDate(self.engine.userInfo!.semesterDate, animated: true)
        }
        self.xn = self.xnArray[xnIdx]
        self.xq = self.xqArray[xqIdx]
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUI()
    }
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        var userInfo = DEDUserInfo()
        userInfo <== [
            "xh"  : self.xhTextField.text,
            //"pwd" : self.pwdTextField.text,
            "xn"  : self.xn,
            "xq"  : self.xq,
            "setSemesterDateManually" : self.setDateManually.on,
            "semesterDate" : self.semesterDatePicker.date
        ]
        self.engine.userInfo = userInfo
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(userInfo)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "DEDUserInfo")
        
        SVProgressHUD.showSuccessWithStatus("保存成功")
        self.xhTextField.resignFirstResponder()
        self.setupUI()
        //self.pwdTextField.resignFirstResponder()
    }
    @IBAction func CleanButtonClicked(sender: AnyObject) {
        for key in ["DEDUserInfo","CourseTableXML","xh_preference","AttendingsJSONData"] {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
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
        if component == 0 {
            xn = xnArray[row]
        }
        else{
            xq = xqArray[row]
        }
    }

}
