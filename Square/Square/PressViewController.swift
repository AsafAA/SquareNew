//
//  PressViewController.swift
//  Steady Square
//
//  Created by Asaf Avidan Antonir on 11/24/15.
//  Copyright © 2015 Asaf Avidan Antonir. All rights reserved.
//

import UIKit

class PressViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
//            let ratio = touch.force/touch.maximumPossibleForce
//            square.center = CGPointMake(squareX, maxY - ratio*(maxY - minY))
//            
//            if gameMode == "training" {
//                scoreLabel.text = String(ratio*385)
//            }
            self.view.backgroundColor = UIColor.blackColor()
        }
    }
}