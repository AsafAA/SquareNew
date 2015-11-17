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
        startLines()
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
        
        initLine(CGFloat(Int(arc4random_uniform(UInt32(viewHeight - 100))) + 50), gapHeight: viewHeight * CGFloat(gapHeightMultiplier()))
        
        NSTimer.scheduledTimerWithTimeInterval(lineGapTime(), target: self, selector: "startLines", userInfo: nil, repeats: false)
    }
    
    func checkState() {
        if collision() {
            square.backgroundColor = UIColor.redColor()
            print("COLLISION")
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
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        square.center = CGPointMake(squareX, maxY)
    }
    
    //==============================
    // MARK: - Game Object initializers
    
    func initSquare() {
        square = UIView(frame: CGRect(x: 0, y: 0, width: squareWidth, height: squareWidth))
        square.backgroundColor = UIColor.blackColor()
        square.center = CGPointMake(viewWidth * 0.15, maxY)
        self.view.addSubview(square)
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "checkState", userInfo: nil, repeats: true)
    }
    
    func initLine(gapY: CGFloat, gapHeight: CGFloat) {
        let lineTopHeight = gapY - gapHeight/2
        let lineBottomHeight = viewHeight - (gapY + gapHeight/2)
        
        let lineTop = UIView(frame: CGRect(x: viewWidth, y: 0, width: lineWidth, height: lineTopHeight))
        let lineBottom = UIView(frame: CGRect(x: viewWidth, y: gapY + gapHeight/2, width: lineWidth, height: lineBottomHeight ))
        lineTop.backgroundColor = UIColor.blackColor()
        lineBottom.backgroundColor = UIColor.blackColor()
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
            "lineTime" : 2.0,
            "gapHeightMultiplier" : 0.15,
            "lineGapTime": 1.0
        ],
        "hard" : [
            "lineTime" : 1.0,
            "gapHeightMultiplier" : 0.12,
            "lineGapTime": 0.75
        ],
        "insane" : [
            "lineTime" : 1.0,
            "gapHeightMultiplier" : 0.075,
            "lineGapTime": 0.5
        ]
    ]
    
    
    let LEVELS = [
        [
//            "background_color": "x",
//            "num_lines": "x",
//            "line_width": "x",
//            "line_duration": "x",
//            "min_gap_y": "x",
//            "max_gap_y": "x",
//            "line_colors": [
//                "x",
//                "x"
//            ]
        ]
    ]
    
    let LEVEL_COUNTS = [
        30
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
}

