//
//  PageViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/21.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    var id = ""
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        //SVProgressHUD.show()
        let baseString = "http://nuaavt.sinaapp.com/chen/dedpageapi.php"
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(baseString, parameters: [ "id" : self.id ],
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let htmlData = responseObject as NSData
                //NSUserDefaults.standardUserDefaults().setObject(jsonData, forKey: "AttendingsJSONData")
                let HTML = NSString(data: htmlData, encoding: NSUTF8StringEncoding)
                self.webView.loadHTMLString(HTML, baseURL: nil)
                //SVProgressHUD.showSuccessWithStatus("载入完成")
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                NSLog("%@", error)
                SVProgressHUD.showErrorWithStatus("请检查网络连接")
            }
        )
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
