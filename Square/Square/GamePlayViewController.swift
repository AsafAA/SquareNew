//
//  ViewController.swift
//  Square
//
//  Created by Asaf Avidan Antonir on 11/9/15.
//  Copyright © 2015 Asaf Avidan Antonir. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    
    var square: UIView!
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var squareWidth: CGFloat = 0.0
    var lineWidth: CGFloat = 0.0
    var squareX: CGFloat = 0.0
    var maxY: CGFloat = 0.0
    var minY: CGFloat = 0.0
    var timer: NSTimer = NSTimer()
    var lineTimer: NSTimer = NSTimer()
    var lines: [UIView] = []
    var currentLevel: Int = 0
    var linesPassed: Int = 0
    var lineNumber: Int = 0
    var gameMode: String! = ""
    let linesPerLevel: Int = 16
    var randomLevelOffset: Int = 0
    @IBOutlet var exitButton: UIButton!
    var tick: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        squareWidth = self.view.frame.height / 30
        lineWidth = squareWidth
        maxY = viewHeight - squareWidth/2
        minY = squareWidth / 2
        squareX = viewWidth * 0.15
        scoreLabel.layer.zPosition = 1
        exitButton.layer.zPosition = 1
        
        exitButton.hidden = (gameMode != "training")
        startGame()
    }
    
    //==============================
    // MARK: - Game States
    
    func startGame() {
        randomLevelOffset = Int(arc4random_uniform(UInt32(LEVELS.count)))
        tick = 0
        linesPassed = 0
        lineNumber = 0
        scoreLabel.text = String("0")
        initSquare()
        startGameLoop()
    }
    
    func startGameLoop() {
        initGapLine()
        
        dispatch_async(dispatch_get_main_queue(),{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: "checkState", userInfo: nil, repeats: true)
        })
    }
    
    func stopGame() {
        print("STOP GAME")
        dispatch_async(dispatch_get_main_queue(),{
            self.timer.invalidate()
        })
        
        square.removeFromSuperview()
        self.view.layer.removeAllAnimations()
        for line in lines {
            line.removeFromSuperview()
        }
        
        lines.removeAll()
    }
    
    func initGapLine() {
        let gapHeight = viewHeight * CGFloat(gapHeightMultiplier())
        
        initLine(CGFloat(Int(arc4random_uniform(UInt32(viewHeight - gapHeight * 1.5))) + Int(gapHeight * 0.75)), gapHeight: gapHeight)
    }
    
    func checkState() {
        let x_distance = viewWidth + squareWidth
        let x_delta = x_distance / (60 * CGFloat(lineTime()))
        for line in lines {
            line.center = CGPointMake(line.center.x - x_delta, line.center.y)
        }
        
        if lines.count > 1 {
            
            let firstLineTop = lines[0]
            let firstLineBottom = lines[1]
            
            if firstLineTop.center.x < 0 - squareWidth / 2 {
                print("NUM LINES")
                print(lines.count)
                
                lines.removeFirst()
                lines.removeFirst()
                firstLineTop.removeFromSuperview()
                firstLineBottom.removeFromSuperview()
                
                if gameMode != "training" {
                    linesPassed += 1
                    scoreLabel.text = String(linesPassed)
                }
            }
            
            
        }
        
        tick += 1
        if tick % (lineGapTime() * 60) == 0 {
            initGapLine()
        }
        
        if gameMode != "training" && collision() {
   
        stopGame()
            
        dismissViewControllerAnimated(false, completion: nil)
//            replayPressed()
        }
    }
    
    func collision() -> Bool {
        for line in self.lines {
            if collide(square, view2: line) {
                return true
            }
        }
        return false
    }
    
    func collide(view1: UIView, view2: UIView) -> Bool {
        
        if let layer1 = view1.layer.presentationLayer() {
            if let layer2 = view2.layer.presentationLayer() {
                let frame1 = layer1.frame
                let frame2 = layer2.frame
                
                return  !((frame1.maxX < frame2.minX) || (frame2.maxX < frame1.minX) || (frame1.maxY < frame2.minY) || (frame2.maxY < frame1.minY))
            }
        }
        
        return false
    }
    
    //==============================
    // MARK: - Touch Callbacks
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
            let ratio = touch.force/touch.maximumPossibleForce
            square.center = CGPointMake(squareX, maxY - ratio*(maxY - minY))
            
            if gameMode == "training" {
                scoreLabel.text = String(ratio)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        square.center = CGPointMake(squareX, maxY)
        
        if gameMode == "training" {
            scoreLabel.text = "0"
        }
    }
    
    //==============================
    // MARK: - Game Object initializers
    
    func initSquare() {
        square = UIView(frame: CGRect(x: 0, y: 0, width: squareWidth, height: squareWidth))
        square.backgroundColor = UIColor.blackColor()
        square.center = CGPointMake(squareX, maxY)
        square.layer.zPosition = 1
        self.view.addSubview(square)
    }
    
    func initLine(gapY: CGFloat, gapHeight: CGFloat) {
        print("INIT LINE")
        print(lineNumber)
        print("LINES PASSED")
        print(linesPassed)
        if true {
            self.linesPassed == 0
            self.scoreLabel.text = String(linesPassed)
        }
        print(linesPassed)
        let lineTopHeight = gapY - gapHeight/2
        let lineBottomHeight = viewHeight - (gapY + gapHeight/2)
        
        let lineTop = UIView(frame: CGRect(x: viewWidth, y: 0, width: lineWidth, height: lineTopHeight))
        let lineBottom = UIView(frame: CGRect(x: viewWidth, y: gapY + gapHeight/2, width: lineWidth, height: lineBottomHeight ))
        lineTop.backgroundColor = getLineColor()
        lineBottom.backgroundColor = getLineColor()
        self.view.addSubview(lineTop)
        self.lines.append(lineTop)
        self.view.addSubview(lineBottom)
        self.lines.append(lineBottom)
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.backgroundColor = self.getBackgroundColor()

            }, completion: nil)
        
        self.lineNumber += 1
    }
    
    //==============================
    // MARK: - Levels
    
    func lineTime() -> Double {
        return MODES[gameMode]!["lineTime"]!
    }
    
    func lineGapTime() -> Double {
        return MODES[gameMode]!["lineGapTime"]!
    }
    
    func gapHeightMultiplier() -> Double {
        return MODES[gameMode]!["gapHeightMultiplier"]!
    }
    
    let MODES = [
        "easy" : [
            "lineTime" : 3.0,
            "gapHeightMultiplier" : 0.3,
            "lineGapTime": 1.5
        ],
        "medium": [
            "lineTime" : 2.8,
            "gapHeightMultiplier" : 0.19,
            "lineGapTime": 1.3
        ],
        "hard" : [
            "lineTime" : 2.5,
            "gapHeightMultiplier" : 0.12,
            "lineGapTime": 0.9
        ],
        "insane" : [
            "lineTime" : 2.5,
            "gapHeightMultiplier" : 0.075,
            "lineGapTime": 0.75
        ],
        "training" : [
            "lineTime" : 2.5,
            "gapHeightMultiplier" : 0.0,
            "lineGapTime": 0.75
        ]
    ]
    
    
    let LEVELS = [
        [
            "background_color": "FEF6EB",
            "line_colors": [
                "525564",
                "96C0CE",
                "BEB9B5",
                "C25B56"
            ]
        ],
        [
            "background_color": "F8DEBD",
            "line_colors": [
                "6F3662",
                "FF7182",
                "FFAE5D",
                "9F6164"
            ]
        ],
        [
            "background_color": "aaaaaa",
            "line_colors": [
                "cccccc",
                "ffffff",
                "333333",
                "777777"
            ]
        ],
        [
            "background_color": "8ED2C9",
            "line_colors": [
                "FF7A5A",
                "00AAA0",
                "FFB85F",
                "462066"
            ]
        ],
        [
            "background_color": "9FBF8C",
            "line_colors": [
                "C8AB65",
                "787A40",
                "F69A98",
                "FFFFFF"
            ]
        ]
        
    ]
    
    //==============================
    // MARK: - Misc
    
    func replayPressed() {
        stopGame()
        startGame()
    }
    
    @IBAction func exitGame(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(),{
            self.timer.invalidate()
            //                self.lineTimer.invalidate()
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func getLineColor() -> UIColor {
        let levelNumber = self.lineNumber / linesPerLevel + randomLevelOffset
        let levelIndex = levelNumber % LEVELS.count
        let lineNumberInLevel = self.lineNumber % linesPerLevel
        let lineColors = LEVELS[levelIndex]["line_colors"]
        let lineColorIndex = lineNumberInLevel % (lineColors?.count)!
        let lineColorHex = lineColors![lineColorIndex]
        return colorWithHexString(lineColorHex as! String)
    }
    
    func getBackgroundColor() -> UIColor {
        let levelNumber = self.lineNumber / linesPerLevel + randomLevelOffset
        let levelIndex = levelNumber % LEVELS.count
        let backgroundColorHex = LEVELS[levelIndex]["background_color"]
        return colorWithHexString(backgroundColorHex as! String)
    }
    
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

