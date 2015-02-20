//
//  Car.swift
//  SwiftArchiverDemo
//
//  Created by Tom Limbaugh on 6/7/14.
//

import Foundation

protocol NSCoding {
    
}

class Car:NSObject {
    
    var year: Int = 0
    var make: String = ""
    var model: String = ""
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeInteger(year, forKey:"year")
        aCoder.encodeObject(model, forKey:"make")
        aCoder.encodeObject(make, forKey:"model")
    }
    
    init(coder aDecoder: NSCoder!) {
        
        super.init()
        
        year = aDecoder.decodeIntegerForKey("year")
        make = aDecoder.decodeObjectForKey("make") as String
        model = aDecoder.decodeObjectForKey("model") as String
        
    }
}



//
//  main.swift
//  SwiftArchiverDemo
//
//  Created by Tom Limbaugh on 6/7/14.
//

import Foundation

var documentDirectories:NSArray
var documentDirectory:String
var path:String
var unarchivedCars:NSArray
var allCars:NSArray

// Create a filepath for archiving.
documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

// Get document directory from that list
documentDirectory = documentDirectories.objectAtIndex(0) as String

// append with the .archive file name
path = documentDirectory.stringByAppendingPathComponent("swift_archiver_demo.archive")

var car1:Car! = Car()
var car2:Car! = Car()
var car3:Car! = Car()

car1.year = 1957
car1.make = "Chevrolet"
car1.model = "Bel Air"

car2.year = 1964
car2.make = "Dodge"
car2.model = "Polara"

car3.year = 1972
car3.make = "Plymouth"
car3.model = "Fury"

allCars = [car1, car2, car3]

// The 'archiveRootObject:toFile' returns a bool indicating
// whether or not the operation was successful. We can use that to log a message.
if NSKeyedArchiver.archiveRootObject(allCars, toFile: path) {
    println("Success writing to file!")
} else {
    println("Unable to write to file!")
}

// Now lets unarchive the data and put it into a different array to verify
// that this all works. Unarchive the objects and put them in a new array
unarchivedCars = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as NSArray

// Output the new array
for car : AnyObject in unarchivedCars {
    println("Here's a \(car.year) \(car.make) \(car.model)")
    
}

//
//  UserInfo.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/16.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class DEDUserInfo: NSObject, NSCoding {
    var xh  = String()
    //var pwd = String()
    var xn  = String()
    var xq  = String()
    var setSemesterDateManually = false
    var semesterDate = NSDate()
    
    override init(){super.init()}
    
    class var keys : [String] {
        return ["xh","xn","xq","setSemesterDateManually","semesterDate"]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        NSLog("DEDUserInfo :: encode")
        aCoder.encodeObject(self.xh, forKey: "xh")
        /*
        for key in DEDUserInfo.keys {
        aCoder.encodeObject(self ?< key, forKey: key)
        }
        */
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        NSLog("DEDUserInfo :: dencode")
        self.xh = aDecoder.decodeObjectForKey("xh") as String
        /*
        for key in DEDUserInfo.keys {
        self.setValue(aDecoder.decodeObjectForKey(key), forKey: key)
        }
        */
    }
    
}

/*

var t = DEDUserInfo()

var data =  NSKeyedArchiver.archivedDataWithRootObject(t)
var defaults = NSUserDefaults.standardUserDefaults()

t.xh = "161300000"
t.xn = "2019-2947"
t.xq = "1"
t.setSemesterDateManually = true

defaults.setObject(data, forKey: "Info")

var newData: NSData = defaults.objectForKey("Info") as NSData
var newObj: DEDUserInfo = NSKeyedUnarchiver.unarchiveObjectWithData(newData) as DEDUserInfo

NSLog("%@", newObj.xh)

*/


var yz = "yvtfytfv&&^BGUYgn&HN*&HN*n2014-20151051330316GVF$%#^%FTVsdfa&G&*H(*JOIJdsf:LKPO:".md5
println(yz);
yz = "chnchbgtyv56rc65EC^%VR%^B67bt76N*&NH*&BTyfvrcd^&BT&^GNYBftfv6vresxs56cVDTYBG^&HG&P>L{PL[p.lp>LP{L"
let urlstr = "http://nuaavt.sinaapp.com/chen/dedclassapi.php?xn=2014-2015&xq=1&xh=051330316&yz1=c74c6522a04207f5996ed6945a923bc0&time=1424455672&yz2=4bb62ca51619b99ee3d78575c8f7a56c"

let url = NSURL(string: urlstr)
let json = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)!

let data = json.dataUsingEncoding(NSUTF8StringEncoding)!

//let dic = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as NSArray

//let ddd = dic.firstObject as [String : String]

//ddd["kcm"]












