//
//  ViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit
import Dollar

class CourseTableViewController: UITableViewController,UIActionSheetDelegate {
    var engine = DedEngine.sharedInstance
    @IBAction func getButtonClicked(sender: AnyObject) {
        SVProgressHUD.show()
        var res = true
        Async.background({
            res = self.engine.getCourseTableBySettings()
        }).main({
            if(res){
                SVProgressHUD.showSuccessWithStatus("获取个人课表成功")
                self.tableView.reloadData()
            }
            else {
                SVProgressHUD.showErrorWithStatus("请先设置学号、学年学期等信息")
            }
        })
    }
    @IBAction func importButtonClicked(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: "导入日历",
                                     delegate: self,
                            cancelButtonTitle: nil,
                       destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("新建日历")
        for (title,cal) in self.engine.calendarDic {
            if(cal.source.title == "iCloud"){
                actionSheet.addButtonWithTitle(title)
            }
        }
        actionSheet.cancelButtonIndex = actionSheet.addButtonWithTitle("取消")
        actionSheet.showFromBarButtonItem(self.navigationController?.navigationBar.topItem?.rightBarButtonItem,animated: true)

        //Async.background({
        //    self.engine.importEvents()
        //})
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
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 0){
            
        }
        else {
            self.engine.calendarDic.values.filter({(cal: EKCalendar) in cal.source.title == "iCloud" })
        }
    }

}

