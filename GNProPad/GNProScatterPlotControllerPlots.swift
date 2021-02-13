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
        plotA.ClearPlot()
        plotB.ClearPlot()
        plotC.ClearPlot()
        SimulatePlot()
    }
    
    
    func SimulatePlot() {
        
        let tsvReader = TSVReader()
        plotData = tsvReader.GetGNXYDataSetFromFile(fileName: "Dfile", fileExt: "tsv")
        
        self.tableView.reloadData()
        self.tableViewB.reloadData()
        
        plotA.AddGNData(DataSet: plotData)
        plotB.AddGNData(DataSet: plotData)
        plotC.AddGNData(DataSet: plotData)
        
        plotA.plotLabelX = "Data CCF-098-23"
        plotA.plotLabelY = "Range VBG-99800-098"
        plotA.TurnOnPlot()
        
        
        plotB.plotLabelX = "IND: XXD-223-0098-23"
        plotB.plotLabelY = "DEP: DDR-009"
        plotB.TurnOnPlot()
        
        
        plotC.plotLabelX = "X: ZX-12-DF"
        plotC.plotLabelY = "Y: GGG-P_09-0"
        plotC.TurnOnPlot()
    }
    
    
    
}
