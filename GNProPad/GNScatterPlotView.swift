//
//  GNScatterPlotView.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

struct XYData {
    var x : Float = 0.0
    var y : Float = 0.0
    var pointColor : UIColor = UIColor.black
    init(x: Float, y: Float, color: UIColor) {
        self.x   = x
        self.y = y
        self.pointColor  = color
    }
}

struct XYDataSet {
    var dValues  = [XYData]()
    var xLabel : String = "X Label"
    var yLabel : String = "Y Label"
}

class GNScatterPlotView: UIView {

    var drawPlot : Bool = false
    var plotData = XYDataSet()
    
    var pCartesianTrans : CGAffineTransform = CGAffineTransform.identity
    
    var xScale : CGFloat = 0.0
    var yScale : CGFloat = 0.0
    
    var scaleTweak :Float = 0.01
    
    var xMin:Float = -5.0
    var yMin:Float = -5.0
    var xMax:Float = 5.0
    var yMax:Float = 5.0
    var xRange : Float = 10.0
    var yRange : Float = 10.0
    
    var markLineWidth:Float = 1.0
    
    var markCGSize = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
    
    func AddDataSet( DataSet inDataSet:XYDataSet){
        plotData = inDataSet
    }
    
    override func draw(_ rect: CGRect)
    {
        //SetScales()
        self.layer.sublayers = nil
        if(drawPlot)
        {
            DrawMark2()
        }
        //ReleaseScales()
    }
    
    func TurnOnPlot()
    {
        drawPlot = true
        setNeedsDisplay()
    }
    
    func DrawPlot()
    {
        for p in plotData.dValues{
            let c = CGPoint( x: CGFloat(p.x), y: CGFloat(p.y) )
            DrawMark(Mark: c, Color:p.pointColor)
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        
        markLineWidth = 0.01
        
        markCGSize = CGSize(width: CGFloat(xRange * scaleTweak), height: CGFloat(yRange * scaleTweak))
        pCartesianTrans = GetCartisianTransform()
    }
    
    
    func GetCartisianTransform() -> CGAffineTransform
    {
        var pTempCartesianTransform : CGAffineTransform = CGAffineTransform.identity
        
        pTempCartesianTransform = pTempCartesianTransform.translatedBy(x: (self.frame.size.width / 2.0), y: (self.frame.size.height / 2.0));
        
        xScale =  (self.frame.width / 1.1) / CGFloat(xRange)
        yScale =  (self.frame.height / 1.1) / CGFloat(yRange)
        
        pTempCartesianTransform = pTempCartesianTransform.scaledBy(x: CGFloat(xScale), y: CGFloat(yScale));
        
        return pTempCartesianTransform
    }
    
    func DrawMark(Mark markPoint:CGPoint, Color markColor : UIColor)
    {
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
                
        // Draw the arc around the circle
        let rad = max(markCGSize.height, markCGSize.width)
        context?.addArc(center: markPoint, radius: rad, startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        
        // Set the fill color (if you are filling the circle)
        context?.setFillColor(markColor.cgColor)
        
        // Set the stroke color
        context?.setStrokeColor(UIColor.blue.cgColor)
        
        // Set the line width
        context?.setLineWidth(CGFloat(markLineWidth))
        
        // Draw the arc
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
        
    }
    func DrawMark2()
    {
        let markColor = UIColor.blue
        // 1
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        // 2
        let radius = max(bounds.width, bounds.height)

        // 3
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = .pi / 0.5

        // 4
        let path = UIBezierPath(
          arcCenter: center,
          radius: radius/10,
          startAngle: startAngle,
          endAngle: endAngle,
          clockwise: true)

        // 5
        path.lineWidth = 10
        markColor.setStroke()
        path.stroke()
        
    }


}
