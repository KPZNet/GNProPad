//
//  GNProMainViewViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

class GNProMainViewViewController: UIViewController {

    @IBOutlet weak var gnScatterPlot: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot2: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot3: GNScatterPlotView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func PlotRandoScatter(Plot plt : GNScatterPlotView) {
        var dataSetXY = XYDataSet()
        
        let xm:Float = 50.0
        let ym:Float = 50.0
        plt.SetupScales(XMin: 0, XMax: CGFloat(xm), YMin: 0, YMax: CGFloat(ym))
        
        for _ in 1...100{
            let randX = Float.random(in: 0...xm)
            let randY = Float.random(in: 0...ym)
            let rBlue = Double.random(in: 0...255)
            let rGreen = Double.random(in: 0...255)
            let rRed = Double.random(in: 0...255)
            let kolor:UIColor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 0.7)
            
            let xy = XYData(x : randX, y:randY, color:kolor)
            dataSetXY.dataValues.append(xy)
            plt.AddDataSet(DataSet: dataSetXY)
        }
        
        plt.TurnOnPlot()
    }
    
    @IBAction func Drser(_ sender: AnyObject) {
        
        PlotRandoScatter(Plot: gnScatterPlot)
        PlotRandoScatter(Plot: gnScatterPlot2)
        PlotRandoScatter(Plot: gnScatterPlot3)
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