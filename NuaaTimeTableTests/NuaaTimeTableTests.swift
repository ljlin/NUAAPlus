//
//  NuaaTimeTableTests.swift
//  NuaaTimeTableTests
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import UIKit
import XCTest

class NuaaTimeTableTests: XCTestCase {
    
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
        var yz = "yvtfytfv&&^BGUYgn&HN*&HN*n2014-20151161310120GVF$%#^%FTVsdfa&G&*H(*JOIJdsf:LKPO:".md5
        let time = NSDate().timeIntervalSince1970
        NSLog("%@", yz)
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
