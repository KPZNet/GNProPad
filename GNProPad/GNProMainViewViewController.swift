//
//  GNProMainViewViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

class GNProMainViewViewController: UIViewController {

    @IBOutlet weak var gnScatterPlot: GNScatterPlotView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Drser(_ sender: AnyObject) {
        gnScatterPlot.DrawMark()
        gnScatterPlot.setNeedsDisplay()
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
