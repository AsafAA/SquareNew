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
    var timer: NSTimer = NSTimer()
    var randomLevelIndex: Int = 0
    var lines: [UIView] = []
    var colorIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleForeground", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleBackground", name:
            UIApplicationDidEnterBackgroundNotification, object: nil)
        
        drawButtons()
    }
    
    func handleForeground() {
        drawBackground()
    }
    
    func handleBackground() {
        removeLines()
    }
    
    func removeLines() {
        for line in lines {
            line.removeFromSuperview()
        }
        lines.removeAll()
        dispatch_async(dispatch_get_main_queue(),{
            self.timer.invalidate()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        randomLevelIndex = Int(arc4random_uniform(UInt32(LEVELS.count)))
        drawButtons()
        drawBackground()
        
//        dispatch_async(dispatch_get_main_queue(),{
//            self.timer = NSTimer.scheduledTimerWithTimeInterval(8.0/10.0, target: self, selector: "addLine", userInfo: nil, repeats: true)
//        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        removeLines()
        
        let gamePlayViewController = (segue.destinationViewController as! GamePlayViewController)
        gamePlayViewController.gameMode = segue.identifier
    }
    
    func addLine() {
        initLine(0, y: self.view.frame.height)
//        print(lines.count)
    }
    
    func initLine(x: CGFloat, y:CGFloat) {
        let width = self.view.frame.height / 30
        let height = self.view.frame.height
        let line = UIView(frame: CGRectMake(0, 0, width, height * 1.5))
        line.userInteractionEnabled = false
        line.center = CGPointMake(x, y)
        line.backgroundColor = getLineColor(colorIndex)
        line.transform = CGAffineTransformMakeRotation(-1 * CGFloat(M_PI) / 6)
        self.view.addSubview(line)
        line.layer.zPosition = 0
        lines.append(line)
        colorIndex += 1
        
        UIView.animateWithDuration(8.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                line.center = CGPointMake(x + self.view.frame.width, y - self.view.frame.height)
            }, completion: { finished in
                line.removeFromSuperview()
                if !self.lines.isEmpty {
                    self.lines.removeFirst()
                }
        })


    }
    
    func diagonalLength() -> CGFloat {
        let width = self.view.frame.width
        let height = self.view.frame.height
        return sqrt(pow(width, 2.0) + pow(height, 2.0))
    }
    
    func moveLines() {
        let width = self.view.frame.height / 30
        
        for line in lines {
            line.center = CGPointMake(line.center.x + 1, line.center.y - 1)
            
            if let lastLine = lines.last {
                if let firstLine = lines.first {
                    if lastLine.center.x > self.view.frame.width && lastLine.center.y < -0.5 * self.view.frame.height {
                        colorIndex += 1
                        lines.removeLast()
                        lines.insert(lastLine, atIndex: 0)
                        lastLine.center = CGPointMake(firstLine.center.x - 2.1 * width, firstLine.center.y + 2.1 * width)
                        lastLine.backgroundColor = getLineColor(colorIndex)
                    }
                }
            }
            
        }
    }
    
    func drawButtons() {
        buttonView.layer.zPosition = 1
        buttonView.layer.cornerRadius = 5
        buttonView.backgroundColor = UIColor.clearColor()
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
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        var x = CGFloat(width)
        var y = CGFloat(0)
        colorIndex = 0
        while x >= 0 || y < height {
            
            initLine(x, y: y)
            x -= width/10
            y += height/10
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(8.0/10.0, target: self, selector: "addLine", userInfo: nil, repeats: true)
        })
        
//        print(lines.count)
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