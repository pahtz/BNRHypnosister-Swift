//
//  BNRHypnosisView.swift
//  BNRHypnosister-Swift
//
//  Created by Paul Yu on 21/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit
import CoreGraphics

class BNRHypnosisView: UIView {

    var circleColor : UIColor = UIColor.lightGrayColor() {
    didSet {
        setNeedsDisplay()
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
        //All BNRHypnosisViews start with a clear background color
        self.backgroundColor = UIColor.clearColor()
    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        println("\(self) was touched")
        
        //Get 3 random numbers between 0 and 1
        let red = Double(arc4random() % 100) / 100.0
        let green = Double(arc4random() % 100) / 100.0
        let blue = Double(arc4random() % 100) / 100.0
        
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        circleColor = randomColor
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        let bounds = self.bounds
        
        //Figure out the centre of the bounds rectangle
        var center = CGPointZero
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0
        
        //The largest circle will circumscribe the view
        let maxRadius : Double  = hypot(bounds.size.width, bounds.size.height) / 2.0
    

        let path = UIBezierPath()
        
        for var currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20 {
            path.moveToPoint(CGPointMake(center.x + currentRadius, center.y))   
            path.addArcWithCenter(center, radius: currentRadius, startAngle: 0.0, endAngle: M_PI * 2.0, clockwise: true)
            //Note this is currentRadius!
        }
        //Configure line width ot 10 points
        path.lineWidth = 10
        
        //Configure the drawing color to light gray
        circleColor.setStroke()
        
        //Draw the line!
        path.stroke()
        
        //logo's rect for calculations
        let logoOriginX = bounds.origin.x
        let logoOriginY = bounds.origin.y + bounds.height / 3.0
        let logoWidth = bounds.width
        let logoHeight = bounds.height / 3.0
        
        //triangle behind logo
        let triangleTop = CGPointMake(logoWidth / 2.0, logoOriginY)
        let triangleBottomLeft = CGPointMake(logoOriginX, logoOriginY + logoHeight)
        let triangleBottomRight = CGPointMake(logoOriginX + logoWidth, logoOriginY + logoHeight)
        let triangleBottomMiddle = CGPointMake(logoOriginX + logoWidth / 2.0, logoOriginY + logoHeight)
        
        //setup the triangle path
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(triangleTop)
        trianglePath.addLineToPoint(triangleBottomLeft)
        trianglePath.addLineToPoint(triangleBottomRight)
        trianglePath.closePath()

        //Clip the gradient to the triangle but save non-clipped state first
        var currentContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(currentContext)
        trianglePath.addClip()
        
        //Setup Gradient
        let locations :CGFloat[] = [ 0.0, 1.0]
        let components :CGFloat[] = [ 0.0, 1.0, 0.0, 1.0, //start color is green
                                    1.0, 1.0, 0.0, 1.0] //end color is yellow
        var colorspace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        var gradient : CGGradientRef = CGGradientCreateWithColorComponents(colorspace, components, locations, 2)

        CGContextDrawLinearGradient(currentContext, gradient, triangleTop, triangleBottomMiddle, 0)
        trianglePath.addClip()
        //CGGradientRelease(gradient)   //crashes
        //CGColorSpaceRelease(colorspace)   //crashes
        
        //Draw the logo ontop
        CGContextRestoreGState(currentContext)  //remove the clippng
        CGContextSaveGState(currentContext) // set shadow can not be removed so save state
        CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3)
        let logoRect = CGRectMake(logoOriginX, logoOriginY, logoWidth, logoHeight)
        let image = UIImage(named: "bnr_logo.png")
        image.drawInRect(logoRect)
        
        CGContextRestoreGState(currentContext)
    }

}
