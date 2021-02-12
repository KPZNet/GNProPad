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
    
    
    func SimulatePlot() {
        
        let tsvReader = TSVReader()
        plotData = tsvReader.LoadResourceDemoFile(fileName: "Dfile", fileExt: "tsv")
        
        self.tableView.reloadData()
        
        gnScatterPlot.AddGNData(DataSet: plotData)
        gnScatterPlot2.AddGNData(DataSet: plotData)
        gnScatterPlot3.AddGNData(DataSet: plotData)
        
        gnScatterPlot.plotLabelX = "Data CCF-098-23"
        gnScatterPlot.plotLabelY = "Range VBG-99800-098"
        gnScatterPlot.TurnOnPlot()
        
        
        gnScatterPlot2.plotLabelX = "IND: XXD-223-0098-23"
        gnScatterPlot2.plotLabelY = "DEP: DDR-009"
        gnScatterPlot2.TurnOnPlot()
        
        
        gnScatterPlot3.plotLabelX = "X: ZX-12-DF"
        gnScatterPlot3.plotLabelY = "Y: GGG-P_09-0"
        gnScatterPlot3.TurnOnPlot()
    }
    
    
    
}
