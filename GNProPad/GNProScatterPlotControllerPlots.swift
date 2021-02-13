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

        SimulatePlot()
    }
    
    func SimulatePlot()
    {
                
        let tsvReader = TSVReader()
        plotData = tsvReader.GetDataSetFromBundleResource(fileName: "Dfile", fileExt: "tsv")
        
        plotA.SetPlotData(DataSet: plotData,plotFormat: PLOT_TYPE.label_type_not_selected)
        plotB.SetPlotData(DataSet: plotData,plotFormat: PLOT_TYPE.label_type_not_selected)
        plotC.SetPlotData(DataSet: plotData,plotFormat: PLOT_TYPE.sub_type)

        self.tableViewA.reloadData()
        self.tableViewB.reloadData()
        
    }
    
    
    
}
