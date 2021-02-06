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
    var relativeSize:Float = 1.0
    init(x: Float = 0.0, y: Float=0.0, color: UIColor = UIColor.black, relSize:Float=1.0) {
        self.x   = x
        self.y = y
        self.relativeSize = relSize
        self.pointColor  = color
    }
}
struct XYTranslatedPlotData {
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
    var plotLabel : String = "Plot Label"
}

class GNScatterPlotView: UIView {

    var drawPlot : Bool = false
    var plotData = [XYDataSet]()
    
    var plotLabelX : String = "Plot Label X"
    var plotLabelY : String = "Plot Label Y"
    
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
    
    var plotMargin : CGFloat = 0.0
    
    var axisLineWidth : CGFloat = 0.0
    var axisLineColor = UIColor.black
    
    var plotDataMarkerScaler:CGFloat = 0.003
    var plotDataMarkerLineScaler:CGFloat = 0.1
    
    var plotAxisLineWidthScaler:CGFloat = 0.001
    
    var plotMarginPercent:CGFloat = 0.04
    
    var plotLabelTextSize = CGSize()
    
    func AddDataSet( DataSet inDataSet:XYDataSet){
        plotData.append(inDataSet)
    }
    
    override func draw(_ rect: CGRect)
    {
        //self.layer.sublayers = nil
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
        DrawAxis()
        DrawPlotAxisLables()
        var i : Int = 0
        for datSet in plotData{
            DrawDataSetLabel(datSet, i)
            i = i + 1
            for p in datSet.dataValues{
                DrawMark(DataPoint: p)
            }
        }

    }
    
    func DrawDataSetLabel(_ dset:XYDataSet, _ row:Int)
    {
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "XXXXXXXXXXX") )
        
        let x = (bounds.width - textSize.width)
        let y = (bounds.height * 0.8) + ( plotLabelTextSize.height * CGFloat(row) )
        let p = CGPoint(x: x, y: y)
        DrawSeriesLabel(dset.plotLabel, p)
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
    }
    
    func SetupScales(XMin inXmin:CGFloat, XMax inXMax:CGFloat, YMin inYmin:CGFloat, YMax inYMax:CGFloat)
    {
        xDataMin = inXmin
        xDataMax = inXMax
        yDataMin = inYmin
        yDataMax = inYMax
        xDataRange = abs(xDataMax - xDataMin)
        yDataRange = abs(yDataMax - yDataMin)
        
        plotMargin = min(bounds.width * plotMarginPercent, bounds.height * plotMarginPercent)
        let plotMargin2 = plotMargin * 2.0
        
        xDataToPlotScale = (bounds.size.width - plotMargin2) / CGFloat(xDataRange)
        yDataToPlotScale = (bounds.size.height - plotMargin2) / CGFloat(yDataRange)
        
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width
        let height = screenBounds.height
        let smallAxis = min(height, width)
        
        plotDataMarkerSize = smallAxis * plotDataMarkerScaler
        
        plotDataMarkerLineWidth = plotDataMarkerSize * plotDataMarkerLineScaler
        axisLineWidth = smallAxis * plotAxisLineWidthScaler
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        plotLabelTextSize = textFont.sizeOfString( NSString(string: "XXX") )
    }
    
    func DataPointToPlotPoint(Value val:XYData) -> XYTranslatedPlotData{
        
        var nValue = XYTranslatedPlotData()
        nValue.x = ( CGFloat(val.x) - xDataMin) * xDataToPlotScale
        nValue.y = (((( CGFloat(val.y) - yDataMin) * yDataToPlotScale)) - bounds.size.height) * -1.0
        
        nValue.x += plotMargin
        nValue.y -= plotMargin
        
        nValue.pointColor = val.pointColor
        return nValue
    }
    
    fileprivate func DrawPlotAxisLables() {
        var xa = CGPoint()
        xa.x = plotMargin/2.0
        xa.y = bounds.height/2.0
        DrawAxisLabel(plotLabelY, xa, true)
        
        var ya = CGPoint()
        ya.x = bounds.width/2.0
        ya.y = bounds.height - (plotMargin/2.0)
        DrawAxisLabel(plotLabelX, ya, false)
    }
    
    func DrawAxis(){
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: plotMargin, y: plotMargin))
        context?.addLine(to: CGPoint(x: plotMargin, y: bounds.height - plotMargin))
        
        context?.setStrokeColor(axisLineColor.cgColor)
        context?.setLineWidth(CGFloat(axisLineWidth))
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        context?.move(to: CGPoint(x: plotMargin, y: bounds.height - plotMargin))
        context?.addLine(to: CGPoint(x: bounds.width - plotMargin, y: bounds.height - plotMargin))
        
        context?.setStrokeColor(axisLineColor.cgColor)
        context?.setLineWidth(CGFloat(axisLineWidth))
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
    }
    
    func DrawMark(DataPoint dataPoint : XYData)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let xyPlotPoint = DataPointToPlotPoint(Value: dataPoint)
        let c = CGPoint(x: xyPlotPoint.x, y: xyPlotPoint.y)
        context?.addArc(center: c, radius: plotDataMarkerSize * CGFloat(dataPoint.relativeSize), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        context?.setFillColor(xyPlotPoint.pointColor.cgColor)
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.setLineWidth(CGFloat(plotDataMarkerLineWidth))
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
    }
    
    func DrawSeriesLabel(_ seriesLabel:String, _ loc:CGPoint, _ rotate:Bool = false )
    {
        var midPoint : CGPoint = CGPoint(x:0, y:0)
        
        midPoint.x = loc.x
        midPoint.y = loc.y
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "XXXXXXXXXX") )
        
        let sRect:CGRect = CGRect(x: midPoint.x, y: midPoint.y, width: textSize.width, height: textSize.height)
        
        let label = UILabel(frame: sRect)
        //label.center = midPoint
        label.font = textFont
        label.textAlignment = NSTextAlignment.left
        
        label.text = seriesLabel
        label.backgroundColor = UIColor.lightText
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        if(rotate)
        {
            var textRotation = CGFloat( .pi/2.0)
            textRotation *= -1.0
            label.transform = CGAffineTransform( rotationAngle: textRotation )
        }
        
        addSubview(label)
    }
    
    func DrawAxisLabel(_ seriesLabel:String, _ loc:CGPoint, _ rotate:Bool = false )
    {
        var midPoint : CGPoint = CGPoint(x:0, y:0)
        
        midPoint.x = loc.x
        midPoint.y = loc.y
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: seriesLabel + "XX") )
        
        let sRect:CGRect = CGRect(x: midPoint.x, y: midPoint.y, width: textSize.width, height: textSize.height)
        
        let label = UILabel(frame: sRect)
        label.center = midPoint
        label.font = textFont
        label.textAlignment = NSTextAlignment.center
        
        label.text = seriesLabel
        //label.backgroundColor = UIColor.lightText
        //label.layer.borderColor = UIColor.darkGray.cgColor
        //label.layer.borderWidth = 0.5
        //label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        if(rotate)
        {
            var textRotation = CGFloat( .pi/2.0)
            textRotation *= -1.0
            label.transform = CGAffineTransform( rotationAngle: textRotation )
        }
        
        addSubview(label)
    }
    
}

extension UIFont {
    func sizeOfString (_ string: NSString) -> CGSize
    {
        return string.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: self],
                                   context: nil).size
    }
}
