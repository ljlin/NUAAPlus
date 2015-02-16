//
//  SchoolCalendarViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/15.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class SchoolCalendarViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var engine = DedEngine.sharedInstance
    var URLString = "http://ded.nuaa.edu.cn/JwSys/Manager/Module/Calendar/Display/CalendarB.aspx"
    override func viewDidLoad() {
        super.viewDidLoad();
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: URLString+"?xn=2014-2015&xq=2")!))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let user = self.engine.userInfo {
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: URLString+"?xn=\(user.xn)&xq=\(user.xq)")!))
        }
    }
}