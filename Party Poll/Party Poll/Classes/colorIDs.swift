//
//  colorIDs.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/2/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import Foundation
import UIKit
class colorIDs {
    func getColorFromID (id: NSString) -> UIColor {
        var colorDict: [String: UIColor] = ["1":#colorLiteral(red: 0.8352941176, green: 0.3764705882, blue: 0.3843137255, alpha: 1),
                                            "2":#colorLiteral(red: 0.02352941176, green: 0.4823529412, blue: 0.7607843137, alpha: 1),
                                            "3":#colorLiteral(red: 0.4392156863, green: 0.8980392157, blue: 0.6078431373, alpha: 1),
                                            "4":#colorLiteral(red: 0.2666666667, green: 0.6862745098, blue: 0.4117647059, alpha: 1),
                                            "5":#colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.05098039216, alpha: 1),
                                            "6":#colorLiteral(red: 0.8497580901, green: 0.4205584339, blue: 0.2592580226, alpha: 1),
                                            "7":#colorLiteral(red: 0.3098039216, green: 0.2039215686, blue: 0.3529411765, alpha: 1),
                                            "8":#colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.4196078431, alpha: 1),
                                            "9":#colorLiteral(red: 0.5957003225, green: 0.9314324239, blue: 0.8547427149, alpha: 1)]
        return colorDict[id as String]!
    }
    
    func getTextColorFromID (id: NSString) -> UIColor {
        var textColorDict: [String: UIColor] = ["1":#colorLiteral(red: 0.9333333333, green: 0.8196078431, blue: 0.8156862745, alpha: 1),
                                                "2":#colorLiteral(red: 0.7568627451, green: 0.8431372549, blue: 0.9215686275, alpha: 1),
                                                "3":#colorLiteral(red: 0.3271282483, green: 0.462745098, blue: 0.3421789212, alpha: 1),
                                                "4":#colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.831372549, alpha: 1),
                                                "5":#colorLiteral(red: 0.4431372549, green: 0.4274509804, blue: 0.3215686275, alpha: 1),
                                                "6":#colorLiteral(red: 0.968627451, green: 0.8470588235, blue: 0.7960784314, alpha: 1),
                                                "7":#colorLiteral(red: 0.7882352941, green: 0.7607843137, blue: 0.8039215686, alpha: 1),
                                                "8":#colorLiteral(red: 0.7411764706, green: 0.7568627451, blue: 0.8196078431, alpha: 1),
                                                "9":#colorLiteral(red: 0.3725490196, green: 0.4901960784, blue: 0.5098039216, alpha: 1)]
        return textColorDict[id as String]!
    }
    
    func getRandomBackgroundColor() -> UIColor {
        var backgroundColors: [UInt32: UIColor] = [1:#colorLiteral(red: 1, green: 0.9894358582, blue: 0.8856310567, alpha: 1),
                                                   2:#colorLiteral(red: 0.9526798666, green: 1, blue: 0.992579446, alpha: 1),
                                                   3:#colorLiteral(red: 0.9650025304, green: 0.9795475203, blue: 1, alpha: 1),
                                                   4:#colorLiteral(red: 0.9215686275, green: 1, blue: 0.9254901961, alpha: 1),
                                                   5:#colorLiteral(red: 1, green: 0.9756336676, blue: 0.9648433954, alpha: 1),
                                                   6:#colorLiteral(red: 0.9609061176, green: 1, blue: 0.9063602535, alpha: 1),
                                                   7:#colorLiteral(red: 0.9091670218, green: 0.9212203308, blue: 1, alpha: 1),
                                                   8:#colorLiteral(red: 1, green: 0.9161433337, blue: 0.9254163889, alpha: 1),
                                                   9:#colorLiteral(red: 0.9250021761, green: 1, blue: 0.9727218649, alpha: 1)]
        return backgroundColors[arc4random_uniform(8) + 1]!
    }
}
