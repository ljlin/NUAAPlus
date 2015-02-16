//
//  ExamListViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class ExamListViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var engine = DedEngine.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad();
        self.webView.scalesPageToFit = true
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://ded.nuaa.edu.cn/NetEa/ExaminationManagement/ViewManagement/List1.aspx?xn=&xq=&type=xh&key=161310120")!))
    }
}
