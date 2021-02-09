//
//  GNProScatterPlotControllerPlots.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/8/21.
//

import Foundation
import UIKit
import GameplayKit


extension GNProMainViewViewController {
    
    func GetNormal(_ low:Int, _ high:Int) -> Int{
        let random = GKRandomSource()
        let dice = GKGaussianDistribution(randomSource: random, lowestValue: low, highestValue: high)
        return dice.nextInt()
    }
    
    func LoadPlotSimulations() {
        gnScatterPlot.ClearPlot()
        gnScatterPlot2.ClearPlot()
        gnScatterPlot3.ClearPlot()
        SimulatePlot()
    }
    
    func MakeDataSet( _ num:Int, _ start:Int, _ end:Int, _ starty:Int, _ endy:Int, _ ssize:Float, _ label:String, _ plt:GNScatterPlotView) {
        
        var dataSetXY = XYDataSet()
        dataSetXY.plotLabel = label
        
        let rBlue = Double.random(in: 0...255)
        let rGreen = Double.random(in: 0...255)
        let rRed = Double.random(in: 0...255)
        let kolor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 0.5)
        
        dataSetXY.setColor = kolor
        for _ in 1...num{
            let randX = GetNormal(start, end)
            let randY = GetNormal(starty,endy)
            let xy = XYData(x : Float(randX), y: Float(randY), color:kolor, relSize: ssize)
            dataSetXY.dataValues.append(xy)
        }
        plt.AddDataSet(DataSet: dataSetXY)
    }
    
    func SimulatePlot() {
        gnScatterPlot.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(100,0, 60, 10, 90, 1.0, "GN09-00", gnScatterPlot)
        MakeDataSet(150,20, 70, 20, 70, 0.5, "GNBf-09", gnScatterPlot)
        MakeDataSet(100,10, 50, 0, 100, 0.7, "SE-09-87", gnScatterPlot)
        MakeDataSet(200,10, 40, 60, 100, 0.3, "BVO09-89", gnScatterPlot)
        MakeDataSet(100,5, 30, 50, 100, 0.8, "OP-00-89", gnScatterPlot)
        gnScatterPlot.plotLabelX = "Data CCF-098-23"
        gnScatterPlot.plotLabelY = "Range VBG-99800-098"
        gnScatterPlot.TurnOnPlot()
        
        gnScatterPlot2.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(100,50, 80, 80, 100, 1.0, "P-098", gnScatterPlot2)
        MakeDataSet(50,20, 70, 10, 70, 0.5, "BM-7-6", gnScatterPlot2)
        MakeDataSet(100,0, 80, 10, 70, 0.2, "CCFG-09-7", gnScatterPlot2)
        MakeDataSet(100,20, 100, 10, 70, 0.3, "UIFG-049-R7", gnScatterPlot2)
        gnScatterPlot2.plotLabelX = "IND: XXD-223-0098-23"
        gnScatterPlot2.plotLabelY = "DEP: DDR-009"
        gnScatterPlot2.TurnOnPlot()
        
        gnScatterPlot3.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(100,0, 80, 10, 90, 1.0, "CB-9-65-8", gnScatterPlot3)
        MakeDataSet(100,20, 50, 20, 65, 0.5, "WED-87", gnScatterPlot3)
        MakeDataSet(300,10, 50, 0, 30, 0.7, "RT-9-5-3", gnScatterPlot3)
        MakeDataSet(100,0, 100, 10, 100, 0.3, "BNMK-0", gnScatterPlot3)
        MakeDataSet(200,70, 100, 40, 100, 1.2, "MKL-09-87", gnScatterPlot3)
        gnScatterPlot3.plotLabelX = "X: ZX-12-DF"
        gnScatterPlot3.plotLabelY = "Y: GGG-P_09-0"
        gnScatterPlot3.TurnOnPlot()
    }
    
    
    
}
