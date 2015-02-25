//
//  ArticlesTableViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/21.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {

    var articles = [[String:String]]()
    var loading = false

    func loadArticles() {
        SVProgressHUD.show()
        self.loading = true
        let baseString = "http://nuaavt.sinaapp.com/chen/dedarticlesapi.php"
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 1
        manager.GET(baseString, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let jsonData = responseObject as NSData
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData( jsonData,
                    options: NSJSONReadingOptions.MutableContainers,
                    error: nil)
                self.articles = jsonObject as [[String:String]]
                //NSUserDefaults.standardUserDefaults().setObject(jsonData, forKey: "AttendingsJSONData")
                SVProgressHUD.showSuccessWithStatus("获取成功")
                self.loading = false
                self.tableView.reloadData()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                NSLog("%@", error)
                SVProgressHUD.showErrorWithStatus("请检查网络连接")
                self.loading = false
            }
        )
    }
    
    // MARK: - Life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.loading {
            SVProgressHUD.show()
        }
        else if articles.isEmpty {
            self.loadArticles()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ArticlescellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.articles[indexPath.row]["title"]

        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        NSLog("accessoryButtonTappedForRowWithIndexPath %@", indexPath)
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("didSelectRowAtIndexPath %@", indexPath)
        self.performSegueWithIdentifier("ShowMoreSegue", sender: indexPath)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMoreSegue" {
            let indexPath = sender as NSIndexPath
            let controller = segue.destinationViewController as PageViewController
            controller.id = self.articles[indexPath.row]["id"]!
        }
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
