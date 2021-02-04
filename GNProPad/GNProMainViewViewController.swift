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
        
        var dataSetXY = XYDataSet()
        
        gnScatterPlot.SetupScales(XMin: -50.0, XMax: 50.0, YMin: -100.0, YMax: 100.0)
        
        for _ in 1...100{
            let randX = Float.random(in: 0...gnScatterPlot.xMax)
            let randY = Float.random(in: 0...gnScatterPlot.yMax)
            let rBlue = Double.random(in: 0...255)
            let rGreen = Double.random(in: 0...255)
            let rRed = Double.random(in: 0...255)
            let kolor:UIColor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 0.5)
            let xy = XYData(x : randX, y:randY, color:kolor)
            dataSetXY.dValues.append(xy)
            gnScatterPlot.AddDataSet(DataSet: dataSetXY)
        }
        gnScatterPlot.TurnOnPlot()
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
