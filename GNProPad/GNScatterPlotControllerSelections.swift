//
//  GNScatterPlotControllerSelections.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/8/21.
//

import Foundation
import UIKit
import GameplayKit


extension GNProMainViewViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(plotData.labels.keys).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "GNScatterCell")!
            
        let labs = Array(plotData.labels.keys)
        
        let c = labs[indexPath.row]
        cell.textLabel?.text = c
        cell.detailTextLabel?.text = "" //String(format: "D %d", indexPath.row)
        return cell
    }
    
    func tableView(_ tableViewW: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let labs = Array(plotData.labels.keys)
        if tableViewW == tableViewA
        {
            let lab = Array(plotData.labels)[indexPath.row].key
            _ = Array(plotData.labels)[indexPath.row].value
            plotA.PlotLabel(label: lab)
            plotA.TurnOnPlot(inType: PLOT_TYPE.label_type)
        }
        if tableViewW == tableViewB
        {
            let lab = Array(plotData.labels)[indexPath.row].key
            _ = Array(plotData.labels)[indexPath.row].value
            plotB.PlotLabel(label: lab)
            plotB.TurnOnPlot(inType: PLOT_TYPE.label_type)
        }
        
    }
    
    
    
}
