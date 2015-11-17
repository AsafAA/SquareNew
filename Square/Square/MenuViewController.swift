//
//  MenuViewController.swift
//  Square
//
//  Created by Asaf Avidan Antonir on 11/15/15.
//  Copyright © 2015 Asaf Avidan Antonir. All rights reserved.
//

import Foundation

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gamePlayViewController = (segue.destinationViewController as! GamePlayViewController)
        gamePlayViewController.gameMode = segue.identifier
    }
}