// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//
//  courseInfo.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/13.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import UIKit

class Info: NSObject {
    var kcm = "aaa"
    var jsm = "bbb"
}

class infocee : UITableViewCell {
    var kcm = "ccc"
    var jsm = "ddd"
}


infix operator ?<  { associativity left precedence 140 }
func ?< (obj : NSObject , key : String) -> AnyObject?{
    return obj.valueForKey(key)
}


var ttt = Info()
var haha = infocee()
let a : String = (ttt ?< "kcm") as String


infix operator <==  { associativity left precedence 140 }

func <== (to:NSObject, rig:(from:NSObject, keys:[String])){
    for key in rig.keys {
        to.setValue(rig.from.valueForKey(key), forKeyPath: key)
    }
}


haha <== (ttt,["kcm"])

haha.kcm

haha.jsm


let infos = [ttt]

for t in infos {
    println(t.kcm)
}

class human : NSObject {
    lazy var name = String();
    override init() {
        super.init()
        self.name = "haha"
    }
    func hello() {
        println(self.name)
    }
}

var t = human()


