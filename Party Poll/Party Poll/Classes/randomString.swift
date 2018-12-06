//
//  randomString.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/2/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import Foundation

func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "123456789"
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 1...len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}
