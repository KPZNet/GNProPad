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
    //var labels : [String:Float]
    var indexLabels = [Float]()
    var x : Float = 0.0
    var y : Float = 0.0
    var pointColor : UIColor = UIColor.black
    var relativeSize:Float = 1.0
    init(X: Float = 0.0, Y: Float=0.0, ID:String, NameID:String, SubType:String, Labels:[String:Float], IndexLabels:[Float])
    {
        self.x = X
        self.y = Y
        self.id = ID
        self.nameID = NameID
        self.subType = SubType
        //self.labels = Labels
        self.indexLabels = IndexLabels
    }
}

class XYGNDataSet {
    var dataValues  = [XYGNData]()
    var labels = [String:Int]()
    var sortedLabels = [String]()
    var subTypes = [String:UIColor]()
    var labelMin:Float = 0.0
    var labelMax:Float = 0.0
    var labelSelected:String = ""
    var setColor = UIColor(cgColor: UIColor.black.cgColor)
}

enum PLOT_TYPE {
    case label_type
    case sub_type
    case no_type
    case label_type_not_selected
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
    var plotMarginData : CGFloat = 0.0
    
    var axisLineWidth : CGFloat = 0.0
    var axisLineColor = UIColor.black
    
    var plotDataMarkerScaler:CGFloat = 0.003
    var plotDataMarkerLineScaler:CGFloat = 0.1
    
    var plotAxisLineWidthScaler:CGFloat = 0.001
    
    var plotMarginPercent:CGFloat = 0.04
    
    var plotLabelTextSize = CGSize()
    
    
    func SetPlotData( DataSet inDataSet:XYGNDataSet, plotFormat:PLOT_TYPE)
    {
        ClearPlot()
        
        plotData = inDataSet
        plotType = plotFormat
        
        let p = plotData
        
        let xmin = p.dataValues.min { a, b in a.x < b.x }
        let xmax = p.dataValues.max { a, b in a.x < b.x }
        let ymin = p.dataValues.min { a, b in a.y < b.y }
        let ymax = p.dataValues.max { a, b in a.y < b.y }
        
        SetupScales(XMin: CGFloat(xmin?.x ?? 0.0), XMax: CGFloat(xmax?.x ?? 0.0), YMin: CGFloat(ymin?.y ?? 0.0), YMax: CGFloat(ymax?.y ?? 0.0))
        
        setNeedsDisplay()
    }
    
    func SetPlotData( resourceFile:String, resourceFileExt:String, plotFormat:PLOT_TYPE)
    {
        let tsvReader = TSVReader()
        plotData = tsvReader.GetDataSetFromBundleResource(fileName: "Dfile", fileExt: "tsv")
        SetPlotData(DataSet: plotData, plotFormat: plotFormat)
    }
    
    fileprivate func ClearPlot()
    {
        plotData = XYGNDataSet()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect)
    {
        for v in subviews
        {
            v.removeFromSuperview()
        }
        
        if plotType == PLOT_TYPE.sub_type
        {
            DrawPlot_SubLabel()
        }
        if plotType == PLOT_TYPE.label_type
        {
            DrawPlot_GeneLabel()
        }
        if plotType == PLOT_TYPE.label_type_not_selected
        {
            DrawPlot_NoType()
        }
        DrawViewBorder()
    }
    
    fileprivate func TurnOnPlot(inType:PLOT_TYPE)
    {
        plotType = inType
        setNeedsDisplay()
    }
    
    fileprivate func DrawPlot_SubLabel()
    {
        //DrawAxis()
        
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
    
    fileprivate func DrawPlot_GeneLabel()
    {
        //DrawAxis()
        let i = plotData.labels[plotData.labelSelected] ?? 0
        let pSorted = plotData.dataValues.sorted { $0.indexLabels[i] < $1.indexLabels[i] }
        for p in pSorted{
            let lVal = p.indexLabels[i]
            let v = ScaleLabelToColor(num: lVal, lmin: plotData.labelMin, lmax: plotData.labelMax)
            let col = UIColor(red: CGFloat((v/255.0)), green: CGFloat((v/255.0)), blue: CGFloat((0/255.0)), alpha: 0.8)
            p.pointColor = col
            DrawMark(DataPoint: p)
        }
        DrawColorGradientAxis()
    }
    
    fileprivate func DrawPlot_NoType()
    {
        //DrawAxis()
        
        let i = plotData.labels[plotData.labelSelected] ?? 0
        let pSorted = plotData.dataValues.sorted { $0.indexLabels[i] < $1.indexLabels[i] }
        for p in pSorted{
            let col = UIColor.clear
            p.pointColor = col
            DrawMark(DataPoint: p)
        }
    }
    
    fileprivate func DrawDataSetSubTypeLabel(_ dset:String, _ col:UIColor, _ row:Int)
    {
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: "XXXXXXXXXXX") )
        let x = (bounds.width - textSize.width)
        let y = (bounds.height * 0.0) + ( plotLabelTextSize.height * CGFloat(row) ) + plotLabelTextSize.height/2
        let p = CGPoint(x: x, y: y)
        DrawSeriesLabel(dset, p, col)
    }
    
    fileprivate func DrawColorGradientAxis()
    {
        
        let view = UIView(frame: CGRect(x: bounds.width - (plotMargin*0.5), y: plotMargin * 2.0, width: (plotMargin*0.5), height: bounds.height - plotMargin * 4))
        view.backgroundColor = UIColor.red
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        
        let sstart = UIColor(red: CGFloat((255/255.0)), green: CGFloat((255/255.0)), blue: CGFloat((0/255.0)), alpha: 1.0)
        let send = UIColor(red: CGFloat((0/255.0)), green: CGFloat((0/255.0)), blue: CGFloat((0/255.0)), alpha: 1.0)
        gradient.colors = [sstart.cgColor, send.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        addSubview(view)
        
        DrawGradientScaler()
    }
    
    fileprivate func DrawGradientScaler() {
        
        let mx = String(format: "%.2f", plotData.labelMax)
        let mn = String(format: "%.2f", plotData.labelMin)
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        var textSize = textFont.sizeOfString( NSString(string: mx) )
        
        var xa = CGPoint()
        xa.x = bounds.width - (textSize.width * 1.1)
        xa.y = plotMargin
        DrawTextString(mx, xa, false)
        
        textSize = textFont.sizeOfString( NSString(string: mn) )
        var ya = CGPoint()
        ya.x = bounds.width - (textSize.width * 1.1)
        ya.y = bounds.height - plotMargin * 2
        DrawTextString(mn, ya, false)
    }

    fileprivate func DrawViewBorder() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    override init(frame aRect: CGRect)
    {
        super.init(frame:aRect)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    fileprivate func SetupScales(XMin inXmin:CGFloat, XMax inXMax:CGFloat, YMin inYmin:CGFloat, YMax inYMax:CGFloat)
    {
        xDataMin = inXmin
        xDataMax = inXMax
        yDataMin = inYmin
        yDataMax = inYMax
        xDataRange = abs(xDataMax - xDataMin)
        yDataRange = abs(yDataMax - yDataMin)
        
        let largeRange = max(xDataRange, yDataRange)
        
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        plotLabelTextSize = textFont.sizeOfString( NSString(string: "XXX") )
        
        plotMargin = plotLabelTextSize.height * 1.5
        plotMarginData = plotMargin * 2.2
        
        _  = CGFloat(1.0)
        
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width
        let height = screenBounds.height
        let smallAxis = min(height, width)
        
        let squareAxis = min (bounds.width, bounds.height)
        let commonDataScale = (squareAxis - plotMarginData) / CGFloat(largeRange)
        
        xDataToPlotScale = commonDataScale
        yDataToPlotScale = commonDataScale
        
        //xDataToPlotScale = (squareAxis - plotMarginData) / CGFloat(xDataRange)
        //yDataToPlotScale = (squareAxis - plotMarginData) / CGFloat(yDataRange)
        
        //xDataToPlotScale = (bounds.size.width - plotMarginData) / CGFloat(xDataRange)
        //yDataToPlotScale = (  (bounds.size.height) - plotMarginData) / CGFloat(yDataRange)
        
        plotDataMarkerSize = smallAxis * plotDataMarkerScaler
        
        plotDataMarkerLineWidth = plotDataMarkerSize * plotDataMarkerLineScaler
        axisLineWidth = smallAxis * plotAxisLineWidthScaler
    }
    
    fileprivate func DataPointToPlotPoint(Value val:XYGNData) -> CGPoint{
        
        var nValue = CGPoint()
        
        var xSpacer = 0.5 * (((( xDataRange ) * xDataToPlotScale)) - bounds.size.width)
        xSpacer -= (plotMarginData * 0.5)
        
        var ySpacer = 0.5 * (((( yDataRange ) * yDataToPlotScale)) - bounds.size.height) * -1.0
        ySpacer -= (plotMarginData * 0.5)
        
        nValue.x =  ((( CGFloat(val.x) - xDataMin) * xDataToPlotScale))
        nValue.y =  (((( CGFloat(val.y) - yDataMin) * yDataToPlotScale)) - bounds.size.height) * -1.0
        
        nValue.x -= xSpacer
        nValue.y -= ySpacer
        
        nValue.x -= (plotMarginData * 0.5)
        nValue.y -= (plotMarginData * 0.5)
        
        return nValue
    }
    
    fileprivate func DrawAxis(){
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
    
    fileprivate func DrawMark(DataPoint dataPoint : XYGNData)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let xyPlotPoint = DataPointToPlotPoint(Value: dataPoint)
        let c = CGPoint(x: xyPlotPoint.x, y: xyPlotPoint.y)
        context?.addArc(center: c, radius: plotDataMarkerSize * CGFloat(dataPoint.relativeSize), startAngle: CGFloat(0), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
                
        context?.setFillColor(dataPoint.pointColor.cgColor)
        context?.setStrokeColor(UIColor.gray.cgColor)
        context?.setLineWidth(CGFloat(plotDataMarkerLineWidth))
        context?.drawPath(using: CGPathDrawingMode.fillStroke) // or kCGPathFillStroke to fill and stroke the circle
    }
    
    fileprivate func DrawSeriesLabel(_ seriesLabel:String, _ loc:CGPoint, _ col:UIColor, _ rotate:Bool = false )
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
    
    fileprivate func DrawTextString(_ textString:String, _ loc:CGPoint, _ rotate:Bool = false )
    {
        let textFont:UIFont = UIFont(name: "Helvetica", size: CGFloat(10))!
        let textSize = textFont.sizeOfString( NSString(string: textString) )
        let sRect:CGRect = CGRect(x: loc.x, y: loc.y, width: textSize.width, height: textSize.height)
        let label = UILabel(frame: sRect)
        //label.center = midPoint
        label.font = textFont
        label.textAlignment = NSTextAlignment.left
        label.text = textString
        label.layer.masksToBounds = true
        if(rotate)
        {
            var textRotation = CGFloat( .pi/2.0)
            textRotation *= -1.0
            label.transform = CGAffineTransform( rotationAngle: textRotation )
        }
        addSubview(label)
    }
    
    fileprivate func DrawLabelSwatch(_ loc:CGRect, _ col:UIColor)
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
    
    fileprivate func ScaleLabelToColor(num:Float, lmin:Float, lmax:Float)->Float
    {
        return ( (num - lmin) / abs(lmin - lmax) ) * 255.0
    }
    
    func SelectGeneLabel(label:String)
    {
        let i = plotData.labels[label] ?? 0
        let xmin = plotData.dataValues.min { a, b in a.indexLabels[i] < b.indexLabels[i] }
        let xmax = plotData.dataValues.max { a, b in a.indexLabels[i] < b.indexLabels[i] }
        plotData.labelMin = xmin?.indexLabels[i] ?? 0.0
        plotData.labelMax = xmax?.indexLabels[i] ?? 0.0
        plotData.labelSelected = label
        TurnOnPlot(inType: PLOT_TYPE.label_type)
        
    }
    
    func GetSamplesInSelection(SelectionBox:CGRect)->XYGNDataSet{
        var dSet = [XYGNData]()
        for d in plotData.dataValues{
            if SelectionBox.contains( DataPointToPlotPoint(Value: d) )
            {
                dSet.append(d)
            }
        }
        let plotDataSet = XYGNDataSet()
        plotDataSet.dataValues = dSet
        plotDataSet.labelMax = 0.0
        plotDataSet.labelMin = 0.0
        plotDataSet.labelSelected = ""
        plotDataSet.labels = plotData.labels
        plotDataSet.subTypes = plotData.subTypes
        plotDataSet.setColor = plotData.setColor
        return plotDataSet
    }
    
}

