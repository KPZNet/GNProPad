//
//  MiniScatterControllerViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/15/21.
//

import Foundation
import UIKit
import GameplayKit

class MiniScatterControllerViewController: UIViewController {

    @IBOutlet weak var plotA: GNScatterPlotView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
    }
    
    func SetPlotData(DataSet: XYGNDataSet, plotFormat: PLOT_TYPE)
    {
        plotA.SetPlotData(DataSet: DataSet, plotFormat: plotFormat)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
