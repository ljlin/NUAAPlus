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
        //engine.GetCourseTableByXh("161310120", xn: "2014-2015", xq: "1")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginbyXh(xh: String) {
        self.engine.GetCourseTableByXh(xh, xn: "2014-2015", xq: "1", success: {
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
        return self.engine.course.count;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "courseInfoCellIdentifier"
        var cell: courseInfoCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as courseInfoCell?
        if cell == nil {
            cell = courseInfoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        let courseInfo = self.engine.course[indexPath.row]
        let week = courseInfo["week"]!.toInt()!
        let unit = courseInfo["unit"]!.toInt()!
        cell?.kcm.text = courseInfo["kcm"]
        cell?.jsm.text = courseInfo["jsm"]
        cell?.roomid.text = courseInfo["roomid"]
        cell?.time.text = "周\(week)第\(unit)-\(unit+1)节"
        return cell!
    }

    @IBAction func importButtonClicked(sender: AnyObject) {
        self.engine.importEvents()
    }
}

