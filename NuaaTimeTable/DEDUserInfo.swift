//
//  UserInfo.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class DEDUserInfo: NSObject, LLKVCoding, NSCoding {
    var xh  = String()
    //var pwd = String()
    var xn  = String()
    var xq  = String()
    var setSemesterDateManually = false
    var semesterDate = NSDate()
    
    //override init(){super.init()}
    
    class var keys : [String] {
        return ["xh","xn","xq","setSemesterDateManually","semesterDate"]
    }
    override init() {
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        for key in DEDUserInfo.keys {
            aCoder.encodeObject(self ?< key, forKey: key)
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        for key in DEDUserInfo.keys {
            self.setValue(aDecoder.decodeObjectForKey(key), forKey: key)
        }
    }

}
