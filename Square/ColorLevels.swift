//
//  ColorLevels.swift
//  Steady Square
//
//  Created by Asaf Avidan Antonir on 11/22/15.
//  Copyright © 2015 Asaf Avidan Antonir. All rights reserved.
//

import Foundation
import UIKit

class ColorLevels {
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}

let LEVELS = [
    [
        "background_color": "FEF6EB",
        "game_over_background_color": "96C0CE",
        "button1_color": "525564",
        "button2_color": "C25B56",
        "button3_color": "BEB9B5",
        "line_colors": [
            "525564",
            "96C0CE",
            "BEB9B5",
            "C25B56"
        ]
    ],
    [
        "background_color": "F8DEBD",
        "game_over_background_color": "FFAE5D",
        "button1_color": "9F6164",
        "button2_color": "FF7182",
        "button3_color": "6F3662",
        "line_colors": [
            "6F3662",
            "FF7182",
            "FFAE5D",
            "9F6164"
        ]
    ],
//    [
//        "background_color": "aaaaaa",
//        "game_over_background_color": "ffffff",
//        "button1_color": "aaaaaa",
//        "button2_color": "333333",
//        "button3_color": "777777",
//        "line_colors": [
//            "cccccc",
//            "ffffff",
//            "333333",
//            "777777"
//        ]
//    ],
    [
        "background_color": "8ED2C9",
        "game_over_background_color": "FFB85F",
        "button1_color": "FF7A5A",
        "button2_color": "00AAA0",
        "button3_color": "462066",
        "line_colors": [
            "FF7A5A",
            "00AAA0",
            "FFB85F",
            "462066"
        ]
    ],
    [
        "background_color": "9FBF8C",
        "game_over_background_color": "FFFFFF",
        "button1_color": "FFB85F",
        "button2_color": "787A40",
        "button3_color": "F69A98",
        "line_colors": [
            "FFB85F",
            "787A40",
            "F69A98",
            "FFFFFF"
        ]
    ]
    
    
]


