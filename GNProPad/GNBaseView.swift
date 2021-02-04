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
    var viewScale: Float = 10.0
    
    override init(frame aRect: CGRect)
    {
        super.init(frame:aRect)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    func SetScales()
    {
        SetupScales()
        PushToCartesianTransform()
    }
    
    func ReleaseScales()
    {
        PopToDefaultTransform()
    }
    
    func SetupScales()
    {
        pCartesianTrans = GetCartisianTransform()
    }
    
    func PushToCartesianTransform()
    {
        UIGraphicsGetCurrentContext()?.saveGState()
        
        let context = UIGraphicsGetCurrentContext()
        context?.concatenate(pCartesianTrans);
        
    }
    
    func PopToDefaultTransform()
    {
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    func GetCartisianTransform() -> CGAffineTransform
    {
        var pTempCartesianTransform : CGAffineTransform = CGAffineTransform.identity
        
        pTempCartesianTransform = pTempCartesianTransform.translatedBy(x: (self.frame.size.width / 2), y: (self.frame.size.height / 2));
        
        xScale =  Float(1.0 * (self.frame.size.width / 2) / CGFloat(viewScale))
        yScale =  Float(1.0 * (self.frame.size.height / 2) / CGFloat(viewScale))
        
        pTempCartesianTransform = pTempCartesianTransform.scaledBy(x: CGFloat(xScale), y: CGFloat(yScale));
        
        return pTempCartesianTransform
    }
    
    func DrawMark()
    {
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
        
        // Find the middle of the circle
        let center = CGPoint(x: 0 , y: 0)
        
        // Draw the arc around the circle
        //CGContextAddArc(context, center.x, center.y, CGFloat(vibScale * 0.04), CGFloat(0), CGFloat(2.0 * M_PI), 1) kpc
        context?.addArc(center: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        
        //var kColor:UIColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.5)
        
        // Set the fill color (if you are filling the circle)
        context?.setFillColor(UIColor.red.cgColor)
        
        // Set the stroke color
        context?.setStrokeColor(UIColor.black.cgColor)
        
        // Set the line width
        context?.setLineWidth(CGFloat(1))
        
        // Draw the arc
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
        
    }
    
}
