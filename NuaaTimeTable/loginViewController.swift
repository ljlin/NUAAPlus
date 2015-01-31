//
//  loginViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit


protocol loginDelegate {
    func loginbyXh(xh:String)
}

class loginViewController: UIViewController {
    var delegate : loginDelegate? = nil
    @IBOutlet weak var xhTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func okButtonClicked(sender: UIButton) {
        self.delegate?.loginbyXh(xhTextField.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
