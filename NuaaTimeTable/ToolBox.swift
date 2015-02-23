//
//  ToolBox.swift
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

func <== (to:NSObject, from:[String:AnyObject?]){
    for (key,value) in from {
        to.setValue(value, forKeyPath:key)
    }
}

protocol LLKVCoding {
    class var keys : [String] { get }
}


extension String {
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        var hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash)
    }
}


func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}