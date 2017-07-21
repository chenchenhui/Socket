//
//  TextArrs.swift
//  Client
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

class TextArrs: NSObject {
    
    fileprivate lazy var arrs : [String] = [String]()
    
    fileprivate var count : Int = 0
    
    init(count: Int) {
        self.count = count
    }
    
    func append(str : String) -> String {
        if arrs.count >= count {
            arrs.removeAll()
            arrs.append(str)
            return str
        } else {
            arrs.append(str)
            var result = ""
            for str in arrs {
                result = result + str + "\n"
            }
            return result
        }
    }
}
