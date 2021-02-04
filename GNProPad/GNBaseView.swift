//
//  GNBaseView.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

class GNBaseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var pCartesianTrans : CGAffineTransform = CGAffineTransform.identity
    
    var xScale : Float = 10.0
    var yScale : Float = 10.0
    var xMin:Float = -5.0
    var yMin:Float = -5.0
    var xMax:Float = 5.0
    var yMax:Float = 5.0
    var xRange : Float = 10.0
    var yRange : Float = 10.0
    
    var viewScale: Float = 10.0
    var markLineWidth:Float = 1.0
    var markSize:Float = 1.0
    
    override init(frame aRect: CGRect)
    {
        super.init(frame:aRect)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        SetupScales(XMin: -5, XMax: 5, YMin: -5, YMax: 5)
    }
    
    func SetScales()
    {
        UIGraphicsGetCurrentContext()?.saveGState()
        
        let context = UIGraphicsGetCurrentContext()
        context?.concatenate(pCartesianTrans);
    }
    
    func ReleaseScales()
    {
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    func SetupScales(XMin inXmin:Float, XMax inXMax:Float, YMin inYmin:Float, YMax inYMax:Float)
    {
        xMin = inXmin
        xMax = inXMax
        yMin = inYmin
        yMax = inYMax
        xRange = abs(xMax - xMin)
        yRange = abs(yMax - yMin)
        
        viewScale = sqrt( pow(xRange, 2.0) + pow(yRange, 2.0))
        
        markLineWidth = viewScale * (0.0005)
        markSize = viewScale * (0.005)
        
        pCartesianTrans = GetCartisianTransform()
    }
    
    
    func GetCartisianTransform() -> CGAffineTransform
    {
        var pTempCartesianTransform : CGAffineTransform = CGAffineTransform.identity
        
        pTempCartesianTransform = pTempCartesianTransform.translatedBy(x: (self.frame.size.width / 2), y: (self.frame.size.height / 2));
        
        xScale =  Float(1.0 * (self.frame.size.width / 2) / CGFloat(xRange))
        yScale =  Float(1.0 * (self.frame.size.height / 2) / CGFloat(yRange))
        
        pTempCartesianTransform = pTempCartesianTransform.scaledBy(x: CGFloat(xScale), y: CGFloat(yScale));
        
        return pTempCartesianTransform
    }
    
    func DrawMark(Mark markPoint:CGPoint)
    {
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
                
        // Draw the arc around the circle
        //CGContextAddArc(context, center.x, center.y, CGFloat(vibScale * 0.04), CGFloat(0), CGFloat(2.0 * M_PI), 1) kpc
        context?.addArc(center: markPoint, radius: CGFloat(markSize), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        
        let kColor:UIColor = UIColor(red: (50.0/255.0), green: (60.0/255.0), blue: (20.0/255.0), alpha: 0.5)
        
        // Set the fill color (if you are filling the circle)
        context?.setFillColor(kColor.cgColor)
        
        // Set the stroke color
        context?.setStrokeColor(UIColor.black.cgColor)
        
        // Set the line width
        context?.setLineWidth(CGFloat(markLineWidth))
        
        // Draw the arc
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
        
    }
    
}
