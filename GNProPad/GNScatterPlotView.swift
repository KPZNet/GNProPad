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
    init(x: Float = 0.0, y: Float=0.0, color: UIColor = UIColor.black) {
        self.x   = x
        self.y = y
        self.pointColor  = color
    }
}
struct XYPlotData {
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var pointColor : UIColor = UIColor.black
    init(x: CGFloat = 0.0, y: CGFloat=0.0, color: UIColor = UIColor.black) {
        self.x   = x
        self.y = y
        self.pointColor  = color
    }
}
struct XYDataSet {
    var dataValues  = [XYData]()
    var xLabel : String = "X Label"
    var yLabel : String = "Y Label"
}

class GNScatterPlotView: UIView {

    var drawPlot : Bool = false
    var plotData = XYDataSet()
    
    var xDataToPlotScale:CGFloat = 0.0
    var yDataToPlotScale:CGFloat = 0.0
    
    var xDataMin:CGFloat = -5.0
    var yDataMin:CGFloat = -5.0
    var xDataMax:CGFloat = 5.0
    var yDataMax:CGFloat = 5.0
    var xDataRange : CGFloat = 10.0
    var yDataRange : CGFloat = 10.0
    
    var plotDataMarkerSize : CGFloat = 0.0
    var plotDataMarkerLineWidth: CGFloat = 0.0
    
    func AddDataSet( DataSet inDataSet:XYDataSet){
        plotData = inDataSet
    }
    
    override func draw(_ rect: CGRect)
    {
        self.layer.sublayers = nil
        if(drawPlot)
        {
            DrawPlot()
        }
    }
    
    func TurnOnPlot()
    {
        drawPlot = true
        setNeedsDisplay()
    }
    
    func DrawPlot()
    {
        for p in plotData.dataValues{
            DrawMark(DataPoint: p)
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
    
    func SetupScales(XMin inXmin:CGFloat, XMax inXMax:CGFloat, YMin inYmin:CGFloat, YMax inYMax:CGFloat)
    {
        xDataMin = inXmin
        xDataMax = inXMax
        yDataMin = inYmin
        yDataMax = inYMax
        xDataRange = abs(xDataMax - xDataMin)
        yDataRange = abs(yDataMax - yDataMin)
        
        xDataToPlotScale = bounds.size.width / CGFloat(xDataRange)
        yDataToPlotScale = bounds.size.height / CGFloat(yDataRange)
        
        let smallAxis = min(bounds.height, bounds.width)
        plotDataMarkerSize = smallAxis * 0.005
        plotDataMarkerLineWidth = plotDataMarkerSize * 0.1
    }
    
    func DataPointToPlotPoint(Value val:XYData) -> XYPlotData{
        
        var nValue = XYPlotData()
        nValue.x = ( CGFloat(val.x) - xDataMin) * xDataToPlotScale
        nValue.y = (((( CGFloat(val.y) - yDataMin) * yDataToPlotScale)) - bounds.size.height) * -1.0
        
        nValue.pointColor = val.pointColor
        return nValue
    }
    

    func DrawMark(DataPoint dataPoint : XYData)
    {
        // Get the context
        let context = UIGraphicsGetCurrentContext()
        
        let xyPlotPoint = DataPointToPlotPoint(Value: dataPoint)
        let c = CGPoint(x: xyPlotPoint.x, y: xyPlotPoint.y)
        // Draw the arc around the circle
        context?.addArc(center: c, radius: plotDataMarkerSize, startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        // Set the fill color (if you are filling the circle)
        context?.setFillColor(xyPlotPoint.pointColor.cgColor)
        
        // Set the stroke color
        context?.setStrokeColor(UIColor.blue.cgColor)
        
        // Set the line width
        context?.setLineWidth(CGFloat(plotDataMarkerLineWidth))
        
        // Draw the arc
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
        
    }
    
}

