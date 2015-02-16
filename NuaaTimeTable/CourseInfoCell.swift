//
//  CourseInfoCell.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/3.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import Foundation
import UIKit

class CourseInfoCell : UITableViewCell {
    @IBOutlet weak var kcm: UILabel!
    @IBOutlet weak var jsm: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var roomid: UILabel!
    class func keys() -> [String] {
        return ["kcm","jsm","time","roomid"]
    }
}