//
//  toolbox.swift
//  NuaaTimeTable
//
//  Created by ljlin on 15/2/14.
//  Copyright (c) 2015年 ljlin. All rights reserved.
//

import Foundation

infix operator ?<  { associativity left precedence 140 }
func ?< (obj : NSObject , key : String) -> AnyObject?{
    return obj.valueForKey(key)
}


infix operator <==  { associativity left precedence 140 }
func <== (to:NSObject, rig:(from:NSObject, keys:[String])){
    for key in rig.keys {
        to.setValue(rig.from.valueForKey(key), forKeyPath: key)
    }
}
