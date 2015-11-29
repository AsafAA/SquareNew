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
//    [
//        "background_color": "3B3A3A",
//        "game_over_background_color": "FFDC8A",
//        "button1_color": "872D7D",
//        "button2_color": "F398E9",
//        "button3_color": "FFC128",
//        "button4_color": "FFDC8A",
//        "line_colors": [
//            "872D7D",
//            "F398E9",
//            "FFC128",
//            "FFDC8A"
//        ],
//        "white": "true"
//    ],
//    [
//        "background_color": "FEF6EB",
//        "game_over_background_color": "96C0CE",
//        "button1_color": "525564",
//        "button2_color": "C25B56",
//        "button3_color": "BEB9B5",
//        "button4_color": "96C0CE",
//        "line_colors": [
//            "525564",
//            "96C0CE",
//            "BEB9B5",
//            "C25B56"
//        ]
//    ],
//    [
//        "background_color": "F8DEBD",
//        "game_over_background_color": "FFAE5D",
//        "button1_color": "9F6164",
//        "button2_color": "FF7182",
//        "button3_color": "6F3662",
//        "button4_color": "FFAE5D",
//        "line_colors": [
//            "6F3662",
//            "FF7182",
//            "FFAE5D",
//            "9F6164"
//        ]
//    ],
//    [
//        "background_color": "8ED2C9",
//        "game_over_background_color": "FFB85F",
//        "button1_color": "FF7A5A",
//        "button2_color": "00AAA0",
//        "button3_color": "462066",
//        "button4_color": "FFB85F",
//        "line_colors": [
//            "FF7A5A",
//            "00AAA0",
//            "FFB85F",
//            "462066"
//        ]
//    ],
//    [
//        "background_color": "9FBF8C",
//        "game_over_background_color": "FFFFFF",
//        "button1_color": "FFB85F",
//        "button2_color": "F69A98",
//        "button3_color": "787A40",
//        "button4_color": "F69A98",
//        "line_colors": [
//            "FFB85F",
//            "787A40",
//            "F69A98",
//            "FFFFFF"
//        ]
//    ],
//    [
//        "background_color": "473E3F",
//        "game_over_background_color": "F9E559", //*
//        "button1_color": "218C8D",
//        "button2_color": "EF7126",
//        "button3_color": "8EDC9D",
//        "button4_color": "EF7126",
//        "line_colors": [
//            "218C8D",
//            "8EDC9D",
//            "EF7126",
//            "F9E559"
//        ],
//        "white": "true"
//    ],
//    [
//        "background_color": "DDDDDD",
//        "game_over_background_color": "80CEB9", //*
//        "button1_color": "2F343A",
//        "button2_color": "41AAC4",
//        "button3_color": "BDB69C",
//        "button4_color": "80CEB9",
//        "line_colors": [
//            "2F343A",
//            "BDB69C",
//            "41AAC4",
//            "80CEB9"
//        ]
//    ],
//    [
//        "background_color": "EECD86",
//        "game_over_background_color": "E18942", //*
//        "button1_color": "7A3E48",
//        "button2_color": "3D3242",
//        "button3_color": "B95835",
//        "button4_color": "E18942",
//        "line_colors": [
//            "7A3E48",
//            "B95835",
//            "3D3242",
//            "E18942"
//        ]
//    ],
////    [
////        "background_color": "FFE9E8",
////        "game_over_background_color": "E47297",
////        "button1_color": "9C1C6B",
////        "button2_color": "AA0114",
////        "button3_color": "000000",
////        "button4_color": "E47297",
////        "line_colors": [
////            "9C1C6B",
////            "AA0114",
////            "000000",
////            "E47297"
////        ]
////    ],
//    [
//        "background_color": "21B6A8",
//        "game_over_background_color": "B67721", //*
//        "button1_color": "7F171F",
//        "button2_color": "177F75",
//        "button3_color": "7F5417",
//        "button4_color": "B67721",
//        "line_colors": [
//            "7F171F",
//            "B67721",
//            "7F5417",
//            "177F75"
//        ]
//    ],
//    [
//        "background_color": "685642",
//        "game_over_background_color": "F4F0CB", //*
//        "button1_color": "B3A580",
//        "button2_color": "B7C68B",
//        "button3_color": "DED29E",
//        "button4_color": "B7C68B",
//        "line_colors": [
//            "F4F0CB",
//            "DED29E",
//            "B7C68B",
//            "B3A580"
//        ]
//    ],
//    [
//        "background_color": "F8E4CC",
//        "game_over_background_color": "8FBCDB", //*
//        "button1_color": "447294",
//        "button2_color": "294052",
//        "button3_color": "153450",
//        "button4_color": "8FBCDB",
//        "line_colors": [
//            "447294",
//            "294052",
//            "153450",
//            "8FBCDB"
//        ]
//    ],
    [
        "background_color": "192823",
        "game_over_background_color": "EBB035", //*
        "button1_color": "218559",
        "button2_color": "06A2CB",
        "button3_color": "DD1E2F",
        "button4_color": "EBB035",
        "line_colors": [
            "218559",
            "06A2CB",
            "EBB035",
            "DD1E2F"
        ],
        "white": "true"
    ],
    [
        "background_color": "FFCBF4",
        "game_over_background_color": "21B6A8", //*
        "button1_color": "B69521",
        "button2_color": "7F1769",
        "button3_color": "177F75",
        "button4_color": "21B6A8",
        "line_colors": [
            "B69521",
            "7F1769",
            "177F75",
            "21B6A8"
        ]
    ]
]


