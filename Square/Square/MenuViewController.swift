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
    
    let colorLevels: ColorLevels = ColorLevels()
    
    @IBOutlet var easyButton: UIButton!
    @IBOutlet var mediumButton: UIButton!
    @IBOutlet var hardButton: UIButton!
    @IBOutlet var insaneButton: UIButton!
    @IBOutlet var trainingButton: UIButton!
    @IBOutlet var buttonView: UIView!
    var randomLevelIndex: Int = 0
    var lines: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        randomLevelIndex = Int(arc4random_uniform(UInt32(LEVELS.count)))
        drawButtons()
        drawBackground()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gamePlayViewController = (segue.destinationViewController as! GamePlayViewController)
        gamePlayViewController.gameMode = segue.identifier
    }
    
    func drawButtons() {
        buttonView.layer.zPosition = 1
        buttonView.layer.cornerRadius = 5
        buttonView.backgroundColor = getBackgroundColor()
        easyButton.backgroundColor = getButtonColor(1)
        easyButton.layer.zPosition = 1
        mediumButton.backgroundColor = getButtonColor(2)
        mediumButton.layer.zPosition = 1
        hardButton.backgroundColor = getButtonColor(3)
        hardButton.layer.zPosition = 1
        insaneButton.backgroundColor = getButtonColor(2)
        insaneButton.layer.zPosition = 1
        trainingButton.backgroundColor = getButtonColor(1)
        trainingButton.layer.zPosition = 1
        
        easyButton.layer.cornerRadius = 5
        mediumButton.layer.cornerRadius = 5
        hardButton.layer.cornerRadius = 5
        insaneButton.layer.cornerRadius = 5
        trainingButton.layer.cornerRadius = 5
    }
    
    func drawBackground() {
        self.view.backgroundColor = getBackgroundColor()
        
        for line in lines {
            line.removeFromSuperview()
        }
        lines.removeAll()
        
        let width = self.view.frame.height / 30
        let height = self.view.frame.height
        var x = CGFloat(width/2)
        var y = self.view.frame.height
        var colorIndex = 0
        while x < self.view.frame.width || y > -0.5 * height {
            
            let line = UIView(frame: CGRectMake(0, 0, width, height * 1.5))
            line.center = CGPointMake(x, y)
            line.backgroundColor = getLineColor(colorIndex)
            line.transform = CGAffineTransformMakeRotation(-1 * CGFloat(M_PI) / 6)
            self.view.addSubview(line)
            line.layer.zPosition = 0
            lines.append(line)
            x += 2.1*width
            y -= 2.1*width
            colorIndex += 1
        }
        
        print(lines.count)
    }
    
    func getBackgroundColor() -> UIColor {
        let backgroundColorHex = LEVELS[randomLevelIndex]["background_color"]
        return colorLevels.colorWithHexString(backgroundColorHex as! String)
    }
    
    func getButtonColor(buttonNumber: Int) -> UIColor {
        let backgroundColorHex = LEVELS[randomLevelIndex]["button" + String(buttonNumber) + "_color"]
        return colorLevels.colorWithHexString(backgroundColorHex as! String)
    }
    
    func getLineColor(lineNumber: Int) -> UIColor {
        let colors = LEVELS[randomLevelIndex]["line_colors"]
        let backgroundColorHex = colors![lineNumber % (colors?.count)!]
        return colorLevels.colorWithHexString(backgroundColorHex as! String)
    }
}