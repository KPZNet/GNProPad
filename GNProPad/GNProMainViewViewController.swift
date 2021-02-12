//
//  GNProMainViewViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit
import GameplayKit

class GNProMainViewViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate{
    
    
    let overlay = UIView()
    var lastPoint = CGPoint(x: 0.0, y: 0.0)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gnScatterPlot: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot2: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot3: GNScatterPlotView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var plotData = XYGNDataSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        // Add tap gesture recognizer to view
        addGestures()
        
        SetupSelectionBox()
    }
    
    @IBAction func Drser(_ sender: AnyObject) {
        
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

}
