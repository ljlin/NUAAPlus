//
//  ViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
    var engine = DedEngine.sharedInstance
    
    @IBAction func getButtonClicked(sender: AnyObject) {
        SVProgressHUD.show()
        var res = true
        Async.background({
            res = self.engine.GetCourseTableBySettings()
        }).main({
            SVProgressHUD.dismiss()
            println(res)
            self.tableView.reloadData()
        })
    }
    @IBAction func importButtonClicked(sender: AnyObject) {
        Async.background({
            self.engine.importEvents()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.engine.courses.count;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "courseInfoCellIdentifier"
        var cell: CourseInfoCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CourseInfoCell?
        if cell == nil {
            cell = CourseInfoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }

        let course = self.engine.courses[indexPath.row]
        for key in CourseInfoCell.keys() {
            cell?.setValue(course.valueForKey(key)!, forKeyPath:key+".text")
        }
        return cell!
    }


}

