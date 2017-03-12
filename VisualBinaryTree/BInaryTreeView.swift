//
//  BInaryNode.swift
//  VisualBinaryTree
//
//  Created by Steven Curtis on 10/03/2017.
//  Copyright © 2017 Steven Curtis. All rights reserved.
//

import UIKit
@IBDesignable

class BinaryNode: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 {didSet{setNeedsDisplay()}}
    @IBInspectable
    var width: CGFloat { return bounds.size.width}
    @IBInspectable
    var height: CGFloat { return bounds.size.height}
    @IBInspectable
    var skullRadius : CGFloat{ return min(width,height) / 2 }
    @IBInspectable
    var skullCenter : CGPoint { return CGPoint(x: bounds.midX,y: bounds.midY) }
    @IBInspectable
    var eyesOpen: Bool = false {didSet{setNeedsDisplay()}}
    @IBInspectable
    var eyeBrowTilt: Double = 0.5 {didSet{setNeedsDisplay()}} // -1 full furrow
    @IBInspectable
    var color: UIColor = UIColor.blue {didSet{setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {didSet{setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature: Double = 1.0 {didSet{setNeedsDisplay()}} //1 full smile, -1 full frown
    
    init(left: Bool, right: Bool, frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed, .ended:
            NSLog("gesture")
            scale *= recognizer.scale
            recognizer.scale=1.0
            let resultString = "pinch - scale = \(scale))"
            NSLog(resultString)
            self.transform = CGAffineTransform(scaleX:scale, y: scale)
            
        //do incremental adjustments, so stops it getting huge. Alternative is to set the scale in one go.
        default:
            break
        }
    }
    

private func pathForLeftDiagonal() -> UIBezierPath
{

    let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
    let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
    let mouthOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
    
    let mouthRect = CGRect (
        x: skullCenter.x - mouthWidth/2,
        y: skullCenter.y + mouthOffset,
        width: mouthWidth,
        height: mouthHeight)
    
    //return UIBezierPath(rect: mouthRect)
    //smileOffset ensures we are always between -1 and 1 for the mouthcurvature, times by the mouth rect. So the offset can actually be anything, what a faff
    let smileOffset = CGFloat(max(-1, min(mouthCurvature,1))) * mouthRect.height
    let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
    let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
    let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 4, y: mouthRect.minY + smileOffset)
    let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 4, y: mouthRect.minY + smileOffset)
    
    //return UIBezierPath(rect: mouthRect)
    let path = UIBezierPath()
    path.move(to: start)
    path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
    path.lineWidth = 5.0
    return path
}




//pinch handler (selector)
func scalePinch(_ pinch: UIPinchGestureRecognizer) {
    NSLog("scale")
    switch pinch.state {
    case .changed,.ended:
        scale *= pinch.scale
        pinch.scale = 1
        let resultString = "pinch - scale = \(scale))"
        NSLog(resultString)
        self.transform = CGAffineTransform(scaleX:scale, y: scale)
        
    default:
        break
    }
}



override func draw(_ rect: CGRect) {
    //let skull = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise:false)
    color.set()
    
    pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
    
    pathForEye(eye: .Left).stroke()
    pathForEye(eye: .Right).stroke()
    pathForMouth().stroke()
    exampleRectMouth().stroke()
    pathForBrow(eye: .Left).stroke()
    pathForBrow(eye: .Right).stroke()
}

//Constants
private struct Ratios {
    static let SkullRadiusToEyeOffset: CGFloat = 3
    static let SkullRadiusToEyeRadius: CGFloat = 10
    static let SkullRadiusToMouthWidth: CGFloat = 1
    static let SkullRadiusToMouthHeight: CGFloat = 3
    static let SkullRadiusToMouthOffset: CGFloat = 3
    static let SkullRediusToBrowOffset: CGFloat = 5
    
}

enum Eye{
    case Left
    case Right
}

private func exampleRectMouth() -> UIBezierPath
{
    let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
    let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
    let mouthOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
    
    let mouthRect = CGRect (
        x: skullCenter.x - mouthWidth/2,
        y: skullCenter.y + mouthOffset,
        width: mouthWidth,
        height: mouthHeight)
    
    return UIBezierPath(rect: mouthRect)
}

private func pathForMouth() -> UIBezierPath
{
    let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
    let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
    let mouthOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
    
    let mouthRect = CGRect (
        x: skullCenter.x - mouthWidth/2,
        y: skullCenter.y + mouthOffset,
        width: mouthWidth,
        height: mouthHeight)
    
    //return UIBezierPath(rect: mouthRect)
    //smileOffset ensures we are always between -1 and 1 for the mouthcurvature, times by the mouth rect. So the offset can actually be anything, what a faff
    let smileOffset = CGFloat(max(-1, min(mouthCurvature,1))) * mouthRect.height
    let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
    let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
    let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 4, y: mouthRect.minY + smileOffset)
    let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 4, y: mouthRect.minY + smileOffset)
    
    //return UIBezierPath(rect: mouthRect)
    let path = UIBezierPath()
    path.move(to: start)
    path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
    path.lineWidth = 5.0
    return path
}
private func getEyeCenter (eye: Eye) -> CGPoint
{
    let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
    var eyeCenter = skullCenter
    eyeCenter.y -= eyeOffset
    switch eye {
    //move left eye left by the offset, and the right eye right by the same amount
    case .Left: eyeCenter.x -= eyeOffset
    case .Right: eyeCenter.x += eyeOffset
    }
    return eyeCenter
}
private func pathForEye(eye: Eye) -> UIBezierPath
{
    let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
    let eyeCenter = getEyeCenter(eye: eye)
    if eyesOpen{
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)}
    else{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
        path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        path.lineWidth = 5.0
        return path
    }
}


private func pathForBrow(eye:Eye) -> UIBezierPath
{
    var tilt = eyeBrowTilt
    switch eye{
    case .Left: tilt *= -1.0
    case .Right: break
    }
    var browCenter = getEyeCenter(eye: eye)
    browCenter.y -= skullRadius / Ratios.SkullRediusToBrowOffset
    let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
    let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
    let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
    let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
    let path = UIBezierPath()
    path.move(to: browStart)
    path.addLine(to: browEnd)
    path.lineWidth = 5.0
    return path
}

//example of internal and external names
private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat)-> UIBezierPath
{
    let path =  UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise:false)
    path.lineWidth = 5.0
    return path
}
}
