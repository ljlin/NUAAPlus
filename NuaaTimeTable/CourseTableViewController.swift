//
//  ViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit
import EventKit

class CourseTableViewController: UITableViewController,UIActionSheetDelegate,UIAlertViewDelegate {
    var engine = DedEngine.sharedInstance
    @IBAction func getButtonClicked(sender: AnyObject) {
        SVProgressHUD.show()
        var res = true
        Async.background({
            res = self.engine.getCourseTableBySettings()
        }).main({
            if res {
                SVProgressHUD.showSuccessWithStatus("刷新成功")
                self.tableView.reloadData()
            }
            else {
                SVProgressHUD.showErrorWithStatus("请先设置信息")
            }
        })
    }
    @IBAction func importButtonClicked(sender: AnyObject) {
        let rightBarButton = self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        var actionSheet = UIActionSheet(title: "导入日历",
                                     delegate: self,
                            cancelButtonTitle: nil,
                       destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("新建日历")
        let calendars = self.engine.calendars
        for cal in calendars {
            actionSheet.addButtonWithTitle(cal.title)
        }
        actionSheet.cancelButtonIndex = actionSheet.addButtonWithTitle("取消")
        actionSheet.showFromBarButtonItem(rightBarButton,animated: true)
    }
    override func viewDidLoad() {
        if EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) != EKAuthorizationStatus.Authorized {
            self.engine.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{(granted:Bool, error:NSError?) in
                if granted {
                }
                else{
                    SVProgressHUD.showErrorWithStatus("请允许NUAA+访问日历")
                }
            })
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.engine.courses.isEmpty {
            self.engine.tryLoadCachedTable()
        }
        if self.engine.courses.isEmpty {
            self.getButtonClicked(self)
        }
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
        switch buttonIndex {
        case 0 :
            var alertView = UIAlertView(title: "新建日历",
                                      message: "为新建的日历取名",
                                     delegate: self,
                            cancelButtonTitle: "取消",
                            otherButtonTitles: "确定")
            alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
            alertView.show()
        case actionSheet.cancelButtonIndex :
            //self.engine.calculateFirstSemesterMonday()
            return
        default:
            SVProgressHUD.show()
            Async.background({
                self.engine.importEvents(self.engine.calendars[buttonIndex-1])
            }).main({
                SVProgressHUD.dismiss()
            })
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            //NSLog("%@",alertView.textFieldAtIndex(0)!.text)
            if(alertView.textFieldAtIndex(0)!.text != ""){
                SVProgressHUD.show()
                Async.background({
                    if let calendar = self.engine.creatCalendarby(alertView.textFieldAtIndex(0)!.text){
                        self.engine.importEvents(calendar)
                        self.engine.calendars = self.engine.getCalendars()
                    }
                }).main({
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
}

