//
//  ViewController.swift
//  Square
//
//  Created by Asaf Avidan Antonir on 11/9/15.
//  Copyright © 2015 Asaf Avidan Antonir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var square: UIView!
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var squareWidth: CGFloat = 0.0
    var squareX: CGFloat = 0.0
    var maxY: CGFloat = 0.0
    var minY: CGFloat = 0.0
    var timer: NSTimer = NSTimer()
    var lines: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        squareWidth = self.view.frame.height / 30
        maxY = viewHeight - squareWidth/2
        minY = squareWidth / 2
        squareX = viewWidth * 0.15
        // Do any additional setup after loading the view, typically from a nib.
        initSquare()
        
        start()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSquare() {
        square = UIView(frame: CGRect(x: 0, y: 0, width: squareWidth, height: squareWidth))
        square.backgroundColor = UIColor.blackColor()
        square.center = CGPointMake(viewWidth * 0.15, maxY)
        self.view.addSubview(square)
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "checkState", userInfo: nil, repeats: true)
    }
    
    func checkState() {
        if collision() {
            square.backgroundColor = UIColor.redColor()
            print("COLLISION")
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
            let ratio = touch.force/touch.maximumPossibleForce
            square.center = CGPointMake(squareX, maxY - ratio*(maxY - minY))
        }
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        square.center = CGPointMake(squareX, maxY)
        
    }
    
    func initLine(gapY: CGFloat, gapHeight: CGFloat) {
        let lineTopHeight = gapY - gapHeight/2
        let lineBottomHeight = viewHeight - (gapY + gapHeight/2)
        
        let lineTop = UIView(frame: CGRect(x: viewWidth, y: 0, width: squareWidth, height: lineTopHeight))
        let lineBottom = UIView(frame: CGRect(x: viewWidth, y: gapY + gapHeight/2, width: squareWidth, height: lineBottomHeight ))
        lineTop.backgroundColor = UIColor.blackColor()
        lineBottom.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineTop)
        self.lines.append(lineTop)
        self.view.addSubview(lineBottom)
        self.lines.append(lineBottom)
        
        UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                lineTop.frame = CGRectMake(0 - self.squareWidth, 0, self.squareWidth, lineTopHeight)
                lineBottom.frame = CGRectMake(0 - self.squareWidth, gapY + gapHeight/2, self.squareWidth, lineBottomHeight)
            }, completion: { finished in
                lineTop.removeFromSuperview()
                lineBottom.removeFromSuperview()
                self.lines.removeFirst()
                self.lines.removeFirst()
            }
        )
    }
    
    func start() {
        initLine(CGFloat(Int(arc4random_uniform(UInt32(viewHeight - 100))) + 50), gapHeight: 100)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "start", userInfo: nil, repeats: false)
    }
}

