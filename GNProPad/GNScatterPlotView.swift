//
//  GNScatterPlotView.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit



class XYGNData {
    var id : String
    var nameID : String
    var subType : String
    var labels : [String:Float]
    var x : Float = 0.0
    var y : Float = 0.0
    var pointColor : UIColor = UIColor.black
    var relativeSize:Float = 1.0
    init(X: Float = 0.0, Y: Float=0.0, ID:String, NameID:String, SubType:String, Labels:[String:Float])
    {
        self.x = X
        self.y = Y
        self.id = ID
        self.nameID = NameID
        self.subType = SubType
        self.labels = Labels
    }
}

class XYGNDataSet {
    var dataValues  = [XYGNData]()
    var labels = [String:UIColor]()
    var subTypes = [String:UIColor]()
    var labelMin:Float = 0.0
    var labelMax:Float = 0.0
    var labelSelected:String = ""
    var xLabel : String = "X Label"
    var yLabel : String = "Y Label"
    var plotLabel : String = "Plot Label"
    var setColor = UIColor(cgColor: UIColor.black.cgColor)
}

enum PLOT_TYPE {
    case label_type
    case sub_type
    case no_type
}


class GNScatterPlotView: UIView {

    var plotData = XYGNDataSet()
    
    var plotType : PLOT_TYPE = PLOT_TYPE.no_type
    
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
    
    
    func AddGNData( DataSet inDataSet:XYGNDataSet){
        plotData = inDataSet
        
        let p = plotData
        
        let xmin = p.dataValues.min { a, b in a.x < b.x }
        let xmax = p.dataValues.max { a, b in a.x < b.x }
        let ymin = p.dataValues.min { a, b in a.y < b.y }
        let ymax = p.dataValues.max { a, b in a.y < b.y }
        
        SetupScales(XMin: CGFloat(xmin?.x ?? 0.0), XMax: CGFloat(xmax?.x ?? 0.0), YMin: CGFloat(ymin?.y ?? 0.0), YMax: CGFloat(ymax?.y ?? 0.0))
    }
    
    func ClearPlot()
    {
        plotData = XYGNDataSet()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect)
    {
        self.layer.sublayers = nil
        if plotType == PLOT_TYPE.sub_type
        {
            DrawPlotSubType()
        }
        if plotType == PLOT_TYPE.label_type
        {
            DrawPlotLabel()
        }
    }
    
    func TurnOnPlot(inType:PLOT_TYPE)
    {
        plotType = inType
        setNeedsDisplay()
    }
    
    func DrawPlotSubType()
    {
        DrawAxis()
        
        for p in plotData.dataValues{
            p.pointColor = plotData.subTypes[p.subType] ?? UIColor.black
            DrawMark(DataPoint: p)
        }
        var j : Int = 0
        for subt in plotData.subTypes
        {
            DrawDataSetSubTypeLabel(subt.key, subt.value, j)
            j = j + 1
        }
    }
    
    func DrawPlotLabel()
    {
        DrawAxis()
        
        plotData.dataValues.sort { $0.labels[plotData.labelSelected] ?? 0.0 <            $1.labels[plotData.labelSelected] ?? 0.0 }
        
        
        for p in plotData.dataValues{
            let lVal = p.labels[plotData.labelSelected] ?? 0.0
            let v = ScaleLabelToColor(num: lVal, lmin: plotData.labelMin, lmax: plotData.labelMax)

            let col = UIColor(red: CGFloat((v/255.0)), green: CGFloat((v/255.0)), blue: CGFloat((0/255.0)), alpha: 0.8)
            
            p.pointColor = col
            DrawMark(DataPoint: p)
        }
        DrawColorGradientAxis()
    }
    
    func DrawDataSetLabel(_ dset:XYGNDataSet, _ row:Int)
    {
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "XXXXXXXXXXX") )
        let x = (bounds.width - textSize.width)
        let y = (bounds.height * 0.8) + ( plotLabelTextSize.height * CGFloat(row) )
        let p = CGPoint(x: x, y: y)
        DrawSeriesLabel(dset.plotLabel, p, dset.setColor)
    }
    
    func DrawDataSetSubTypeLabel(_ dset:String, _ col:UIColor, _ row:Int)
    {
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "XXXXXXXXXXX") )
        let x = (bounds.width - textSize.width)
        let y = (bounds.height * 0.0) + ( plotLabelTextSize.height * CGFloat(row) )
        let p = CGPoint(x: x, y: y)
        DrawSeriesLabel(dset, p, col)
    }
    
    func DrawColorGradientAxis()
    {
        
        let view = UIView(frame: CGRect(x: plotMargin, y: plotMargin, width: plotMargin * -0.5, height: bounds.height - plotMargin * 2))
        view.backgroundColor = UIColor.red
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        
        let start = UIColor(red: CGFloat((255/255.0)), green: CGFloat((255/255.0)), blue: CGFloat((0/255.0)), alpha: 1.0)
        let send = UIColor(red: CGFloat((0/255.0)), green: CGFloat((0/255.0)), blue: CGFloat((0/255.0)), alpha: 1.0)
        //gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradient.colors = [start.cgColor, send.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        addSubview(view)        
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
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        plotLabelTextSize = textFont.sizeOfString( NSString(string: "XXX") )
        
        plotMargin = plotLabelTextSize.height * 1.5
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
    }
    
    fileprivate func DataPointToPlotPoint(Value val:XYGNData) -> CGPoint{
        
        var nValue = CGPoint()
        nValue.x = ( CGFloat(val.x) - xDataMin) * xDataToPlotScale
        nValue.y = (((( CGFloat(val.y) - yDataMin) * yDataToPlotScale)) - bounds.size.height) * -1.0
        
        nValue.x += plotMargin
        nValue.y -= plotMargin
        
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
    
    func DrawMark(DataPoint dataPoint : XYGNData)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let xyPlotPoint = DataPointToPlotPoint(Value: dataPoint)
        let c = CGPoint(x: xyPlotPoint.x, y: xyPlotPoint.y)
        context?.addArc(center: c, radius: plotDataMarkerSize * CGFloat(dataPoint.relativeSize), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        context?.setFillColor(dataPoint.pointColor.cgColor)
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.setLineWidth(CGFloat(plotDataMarkerLineWidth))
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
    }
    
    func DrawSeriesLabel(_ seriesLabel:String, _ loc:CGPoint, _ col:UIColor, _ rotate:Bool = false )
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
        
        DrawLabelSwatch(sRect, col)
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
        label.layer.masksToBounds = true
        if(rotate)
        {
            var textRotation = CGFloat( .pi/2.0)
            textRotation *= -1.0
            label.transform = CGAffineTransform( rotationAngle: textRotation )
        }
        addSubview(label)
    }
    
    func DrawLabelSwatch(_ loc:CGRect, _ col:UIColor)
    {
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "X") )
        let sRect:CGRect = CGRect(x: loc.minX - (2.0*textSize.width), y: loc.minY, width: textSize.height, height: textSize.height)
        
        let context = UIGraphicsGetCurrentContext()
        
        let c = CGPoint(x: sRect.midX, y: sRect.midY)
        context?.addArc(center: c, radius: CGFloat(textSize.width/2.0), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        context?.setFillColor(col.cgColor)
        context?.setStrokeColor(col.cgColor)
        context?.setLineWidth(CGFloat(1))
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
    }
    
    func ScaleLabelToColor(num:Float, lmin:Float, lmax:Float)->Float
    {
        return ( (num - lmin) / abs(lmin - lmax) ) * 255.0
    }
    
    func PlotLabel(label:String)
    {
        let xmin = plotData.dataValues.min { a, b in a.labels[label] ?? 0.0 < b.labels[label] ?? 0.0 }
        let xmax = plotData.dataValues.max { a, b in a.labels[label] ?? 0.0 < b.labels[label] ?? 0.0 }
        plotData.labelMin = xmin?.labels[label] ?? 0.0
        plotData.labelMax = xmax?.labels[label] ?? 0.0
        plotData.labelSelected = label
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
