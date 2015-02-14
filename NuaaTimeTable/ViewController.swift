//
//  ViewController.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,loginDelegate {
    var engine = DedEngine()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginbyXh("161310120")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loginbyXh(xh: String) {
        self.engine.GetCourseTableByXh(xh, xn: "2014-2015", xq: "2", success: {
            self.tableView.reloadData()
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "loginSegue"){
            var destination = segue.destinationViewController as loginViewController
            destination.delegate = self
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.engine.courses.count;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "courseInfoCellIdentifier"
        var cell: courseInfoCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as courseInfoCell?
        if cell == nil {
            cell = courseInfoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }

        let course = self.engine.courses[indexPath.row]
        for key in courseInfoCell.keys() {
            cell?.setValue(course.valueForKey(key)!, forKeyPath:key+".text")
        }
        return cell!
    }

    @IBAction func importButtonClicked(sender: AnyObject) {
        self.engine.importEvents()
    }
}

