//
//  UserInfoTest.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/20.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit
import Foundation
import XCTest

class UserInfoTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        var t = DEDUserInfo()
        

        
        t.xh = "161300000"
        t.xn = "2019-2947"
        t.xq = "1"
        t.setSemesterDateManually = true
        
        var data =  NSKeyedArchiver.archivedDataWithRootObject(t)
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: "Info")
        
        var newData: NSData = defaults.objectForKey("Info") as NSData
        var newObj: DEDUserInfo = NSKeyedUnarchiver.unarchiveObjectWithData(newData) as DEDUserInfo
        
        NSLog("%@", newObj.xh)
        
        for key in DEDUserInfo.keys {
            println(newObj ?< key)
        }
        
        
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
