//
//  NTNumber.swift
//  NumberTweeningLibrary
//
//  Created by Michał Szyszka on 10.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit

public class NTNumber: UIView {

    //MARK: Fields
    static let lastAnimationStep = 10
    
    var configuration = NTNumberConfiguration()
    
    var currentFrame = 0
    var nextFrame = 0
    var animationStep = lastAnimationStep
    
    var path = UIBezierPath()
    var numberHelper: NTNumberHelper?
    
    //MARK: Inits
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(frame: CGRect, configuration: NTNumberConfiguration) {
        self.init(frame: frame)
        self.configuration = configuration
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        self.numberHelper = NTNumberHelper(frame: frame)
    }
    
    //MARK: Functions
    
    public func setValue(toDisplay: Int){
        nextFrame = toDisplay
        redrawView()
    }
    
    public func increase(){
        animationStep = 0
        currentFrame = nextFrame;
        nextFrame += 1
        
        if (nextFrame == NTNumber.lastAnimationStep) {
            nextFrame = 0;
        }
        
        redrawView()
    }
    
    override public func draw(_ rect: CGRect) {
        clearPath()
        preparePath()
        drawPath()
        
        animationStep += 1;
        if (animationStep == NTNumber.lastAnimationStep) {
            return
        }
        
        redrawView()
    }
    
    //MARK: Private
    
    private func redrawView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + configuration.animationSpeedSeconds) { [unowned self] in
            self.setNeedsDisplay()
        }
    }
    
    private func drawPath(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = configuration.color
        shapeLayer.lineWidth = CGFloat(configuration.lineWidth)
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    private func preparePath(){
        let fraction = getInterpolatedFraction()
        
        var currentPoints = numberHelper!.getPointsForFrame(frame: currentFrame)
        var nextPoints = numberHelper!.getPointsForFrame(frame: nextFrame)
        
        var currentControlPoints1 = numberHelper!.getControlPoints1ForFrame(frame: currentFrame)
        var nextControlPoints1 = numberHelper!.getControlPoints1ForFrame(frame: nextFrame)
        
        var currentControlPoints2 = numberHelper!.getControlPoints2ForFrame(frame: currentFrame)
        var nextControlPoints2 = numberHelper!.getControlPoints2ForFrame(frame: nextFrame)
        
        let startingPoint = CGPoint(x: CGFloat(currentPoints[0].0 + (nextPoints[0].0 - currentPoints[0].0) * fraction),
                                    y: CGFloat(currentPoints[0].1 + (nextPoints[0].1 - currentPoints[0].1) * fraction))
        
        path.move(to: startingPoint)
        for i in 1..<5 {
            let targetX = currentPoints[i].0 + ((nextPoints[i].0 - currentPoints[i].0) * fraction)
            let targetY = currentPoints[i].1 + ((nextPoints[i].1 - currentPoints[i].1) * fraction)
            let target = CGPoint(x: CGFloat(targetX), y: CGFloat(targetY))
            
            let j = i - 1
            let checkpoint1X = currentControlPoints2[j].0 + ((nextControlPoints2[j].0 - currentControlPoints2[j].0) * fraction)
            let checkpoint1Y = currentControlPoints2[j].1 + ((nextControlPoints2[j].1 - currentControlPoints2[j].1) * fraction)
            let checkpoint1 = CGPoint(x: CGFloat(checkpoint1X), y: CGFloat(checkpoint1Y))
            
            let checkpoint0X = currentControlPoints1[j].0 + ((nextControlPoints1[j].0 - currentControlPoints1[j].0) * fraction)
            let checkpoint0Y = currentControlPoints1[j].1 + ((nextControlPoints1[j].1 - currentControlPoints1[j].1) * fraction)
            let checkpoint0 = CGPoint(x: CGFloat(checkpoint0X), y: CGFloat(checkpoint0Y))
            
            path.addCurve(to: target, controlPoint1: checkpoint0, controlPoint2: checkpoint1)
        }
    }
    
    private func clearPath() {
        path.removeAllPoints()
        layer.sublayers?.removeAll()
    }

    private func getInterpolatedFraction() -> Float{
        var currentStep = 0
        if (animationStep < 2) {
            currentStep = 0;
        } else if (animationStep > 8) {
            currentStep = 6;
        } else {
            currentStep = animationStep - 2;
        }
        let fraction = Float(currentStep) / 6.0
        
        return fraction
    }
}
