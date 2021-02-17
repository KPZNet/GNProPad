//
//  GNProMainViewViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

class GNProMainViewViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate{
        
    let overlay = UIView()
    
    var lastPoint = CGPoint(x: 0.0, y: 0.0)
    
    @IBOutlet weak var plotA: GNScatterPlotView!
    @IBOutlet weak var plotB: GNScatterPlotView!
    @IBOutlet weak var plotC: GNScatterPlotView!
    
    @IBOutlet weak var tableViewA: UITableView!
    @IBOutlet weak var tableViewB: UITableView!
    
    //@IBOutlet weak var cntView: UIContentContainer!

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var miniScatterView: MiniScatterControllerViewController!
    
    
    var plotData = XYGNDataSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to view
        //addGestures()
        
        mView.isHidden = true
        
        SetupSelectionBox()
    }
    
    @IBAction func PlotCellScatter(_ sender: AnyObject) {
        
        //newView.isHidden = true
        SimulatePlot()
        
    }
    
    @IBAction func LoadFiler(_ sender: AnyObject) {
        

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
            if segue.identifier == "MiniScatterSeg"
            {
                if let msv = segue.destination as? MiniScatterControllerViewController
                {
                    self.miniScatterView = msv
                }
            }
    }

}
