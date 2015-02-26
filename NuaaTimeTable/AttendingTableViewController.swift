//
//  AttendingTableViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/20.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class AttendingTableViewController: UITableViewController {
    var engine = DedEngine.sharedInstance
    var attendings = [[String:String]]()

    func analyzeJSONData(data:NSData){
        self.attendings.removeAll(keepCapacity: false)
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData( data,
                                                        options: NSJSONReadingOptions.MutableContainers,
                                                          error: nil)
        if let array = jsonObject as? [[String:String]] {
            self.attendings = array
        }
        self.tableView.reloadData()
    }

    // MARK: - IBACtions
    @IBAction func getButtonClicked(sender: AnyObject) {
        if let user =  self.engine.userInfo {
            SVProgressHUD.show()
            let baseString = "http://nuaavt.sinaapp.com/chen/dedclassapi.php"
            let parameter = DEDClassParameter(user)
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.GET(baseString, parameters: parameter,
                success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    let jsonData = responseObject as NSData
                    self.analyzeJSONData(jsonData)
                    NSUserDefaults.standardUserDefaults().setObject(jsonData, forKey: "AttendingsJSONData")
                    SVProgressHUD.showSuccessWithStatus("刷新成功")
                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    NSLog("%@", error)
                    SVProgressHUD.showErrorWithStatus("请检查网络连接")

                }
            )
        }
        else {
            SVProgressHUD.showErrorWithStatus("请先设置信息")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.attendings.isEmpty {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("AttendingsJSONData") as? NSData {
                self.analyzeJSONData(data)
            }
        }
        if self.attendings.isEmpty {
            self.getButtonClicked(self)
        }
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.attendings.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AttendingCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        if cell == nil {
            cell =  UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        let info    = self.attendings[indexPath.section]
        let key     = info.keys.array[indexPath.row]
        let title   = [
            "kch"     : "课程号",
            "kcm"     : "课程名",
            "kcxh"    : "课程序号",
            "ksxz"    : "考试性质",
            "kclb"    : "课程类别",
            "subkclb" : "子课程类别"
        ][key]
        let content = info[key]
        cell!.textLabel?.text       = title
        cell!.detailTextLabel?.text = content
        return cell!
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
