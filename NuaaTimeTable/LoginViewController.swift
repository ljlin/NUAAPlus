//
//  loginViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit


protocol LoginDelegate {
    func GetCourseTableByXh(xh : String,xn : String, xq : String)
}

class LoginViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var delegate : LoginDelegate? = nil
    @IBOutlet weak var xhTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func okButtonClicked(sender: UIButton) {
        self.delegate?.GetCourseTableByXh(self.xhTextField.text, xn: xn, xq: xq)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let xnArray = ["2014-2015","2015-2016","2016-2017"]
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
        if component == 0 {
            xn = xnArray[row]
        }
        else{
            xq = xqArray[row]
        }
    }
}
