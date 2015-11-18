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
    var lines: [UIView] = []
    var gameRunning: Bool = false
    var currentLevel: Int = 0
    var linesPassed: Int = 0
    var lineNumber: Int = 0
    var gameMode: String! = ""
    
    
    override func viewDidLayoutSubviews() {
        print("VIEW DID LAYOUT SUBVIEWS")
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        squareWidth = self.view.frame.height / 30
        lineWidth = squareWidth
        maxY = viewHeight - squareWidth/2
        minY = squareWidth / 2
        squareX = viewWidth * 0.15
        // Do any additional setup after loading the view, typically from a nib.
        
        startGame()
    }
    
    

    override func viewDidLoad() {
        print( "VIEW DID LOAD" )
        super.viewDidLoad()
        print(gameMode)
        print(MODES)
        
    }
    
    //==============================
    // MARK: - Game States
    
    func startGame() {
        if gameRunning {
            return
        }
        
        linesPassed = 0
        scoreLabel.text = String(linesPassed)
        gameRunning = true
        initSquare()
        if gameMode != "training" {
            
            startLines()
        }
    }
    
    func stopGame() {
        gameRunning = false
        square.removeFromSuperview()
        
        for line in lines {
            line.removeFromSuperview()
        }
        
        lines.removeAll()
    }

    func startLines() {
        if !gameRunning {
            return
        }
        
        let gapHeight = viewHeight * CGFloat(gapHeightMultiplier())
        initLine(CGFloat(Int(arc4random_uniform(UInt32(viewHeight - gapHeight * 1.5))) + Int(gapHeight * 0.75)), gapHeight: gapHeight)
        
        NSTimer.scheduledTimerWithTimeInterval(lineGapTime(), target: self, selector: "startLines", userInfo: nil, repeats: false)
    }
    
    func checkState() {
        if collision() {
            stopGame()
            square.frame = CGRectMake(0, 0, viewWidth, viewHeight)
            dismissViewControllerAnimated(false, completion: nil)
        } else {
            square.backgroundColor = UIColor.blackColor()
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
        self.view.addSubview(square)
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "checkState", userInfo: nil, repeats: true)
    }
    
    func initLine(gapY: CGFloat, gapHeight: CGFloat) {
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
        
        self.lineNumber += 1
        
        UIView.animateWithDuration(lineTime(), delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            lineTop.frame = CGRectMake(0 - self.lineWidth, 0, self.lineWidth, lineTopHeight)
            lineBottom.frame = CGRectMake(0 - self.lineWidth, gapY + gapHeight/2, self.lineWidth, lineBottomHeight)
            }, completion: { finished in
                self.linesPassed += 1
                self.scoreLabel.text = String(self.linesPassed)
                lineTop.removeFromSuperview()
                lineBottom.removeFromSuperview()
                
                // Lines may have been removed by stopGame()
                if !self.lines.isEmpty {
                    self.lines.removeFirst()
                }
                if !self.lines.isEmpty {
                    self.lines.removeFirst()
                }
            }
        )
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
            "gapHeightMultiplier" : 0.15,
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
        ]
    ]
    
    
    let LEVELS = [
        [
            "background_color": "000000",
            "line_colors": [
                "cccccc",
                "eeeeee",
                "000000"
            ]
        ]
    ]
    
    //==============================
    // MARK: - Misc
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func getLineColor() -> UIColor {
        let levelNumber = self.lineNumber / 5
        let levelIndex = levelNumber % LEVELS.count
        let lineNumberInLevel = self.lineNumber % 5
        let lineColors = LEVELS[levelIndex]["line_colors"]
        let lineColorIndex = lineNumberInLevel % (lineColors?.count)!
        let lineColorHex = lineColors![lineColorIndex]
        return colorWithHexString(lineColorHex as! String)
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

