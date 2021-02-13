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
        
        self.tableViewA.reloadData()
        self.tableViewB.reloadData()
        
        plotA.AddGNData(DataSet: plotData)
        plotB.AddGNData(DataSet: plotData)
        plotC.AddGNData(DataSet: plotData)
        
        
        plotC.TurnOnPlot(inType: PLOT_TYPE.sub_type)
    }
    
    
    
}
