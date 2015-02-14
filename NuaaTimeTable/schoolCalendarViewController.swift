//
//  schoolCalendarViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/15.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class schoolCalendarViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://ded.nuaa.edu.cn/JwSys/Manager/Module/Calendar/Display/CalendarB.aspx?xn=2014-2015&xq=2")!))
    }
}