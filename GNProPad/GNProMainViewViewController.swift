//
//  GNProMainViewViewController.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit
import GameplayKit

class GNProMainViewViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var gnScatterPlot: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot2: GNScatterPlotView!
    @IBOutlet weak var gnScatterPlot3: GNScatterPlotView!
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "GNScatterCell")!
            
        let c = String(format: "Selection Cell %d", indexPath.row)
        cell.textLabel?.text = c
        cell.detailTextLabel?.text = String(format: "D %d", indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //tableView.dataSource = self
    }
    
    fileprivate func GetNormal(_ low:Int, _ high:Int) -> Int{
        let random = GKRandomSource()
        let dice = GKGaussianDistribution(randomSource: random, lowestValue: low, highestValue: high)
        return dice.nextInt()
    }
    
    fileprivate func MakeDataSet( _ start:Int, _ end:Int, _ starty:Int, _ endy:Int, _ ssize:Float, _ label:String, _ plt:GNScatterPlotView) {
        
        var dataSetXY = XYDataSet()
        dataSetXY.plotLabel = label
        
        let rBlue = Double.random(in: 0...255)
        let rGreen = Double.random(in: 0...255)
        let rRed = Double.random(in: 0...255)
        let kolor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 0.5)
        
        for _ in 1...100{
            let randX = GetNormal(start, end)
            let randY = GetNormal(starty,endy)
            let xy = XYData(x : Float(randX), y: Float(randY), color:kolor, relSize: ssize)
            dataSetXY.dataValues.append(xy)
        }
        plt.AddDataSet(DataSet: dataSetXY)
    }
    
    @IBAction func Drser(_ sender: AnyObject) {
        
        gnScatterPlot.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(0, 60, 10, 90, 1.0, "GN09-00", gnScatterPlot)
        MakeDataSet(20, 70, 20, 70, 0.5, "GNBf-09", gnScatterPlot)
        MakeDataSet(10, 50, 0, 100, 0.7, "SE-09-87", gnScatterPlot)
        MakeDataSet(10, 40, 60, 100, 0.3, "BVO09-89", gnScatterPlot)
        MakeDataSet(5, 30, 50, 100, 0.8, "OP-00-89", gnScatterPlot)
        gnScatterPlot.plotLabelX = "Data CCF-098-23"
        gnScatterPlot.plotLabelY = "Range VBG-99800-098"
        gnScatterPlot.TurnOnPlot()
        
        gnScatterPlot2.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(50, 80, 80, 100, 1.0, "P-098", gnScatterPlot2)
        MakeDataSet(20, 70, 10, 70, 0.5, "BM-7-6", gnScatterPlot2)
        MakeDataSet(0, 80, 10, 70, 0.2, "CCFG-09-7", gnScatterPlot2)
        MakeDataSet(20, 100, 10, 70, 0.3, "UIFG-049-R7", gnScatterPlot2)
        gnScatterPlot2.plotLabelX = "IND: XXD-223-0098-23"
        gnScatterPlot2.plotLabelY = "DEP: DDR-009"
        gnScatterPlot2.TurnOnPlot()
        
        gnScatterPlot3.SetupScales(XMin: 0.0, XMax: 100.0, YMin: 0.0, YMax: 100.0)
        MakeDataSet(0, 80, 10, 90, 1.0, "CB-9-65-8", gnScatterPlot3)
        MakeDataSet(20, 50, 20, 65, 0.5, "WED-87", gnScatterPlot3)
        MakeDataSet(10, 50, 0, 30, 0.7, "RT-9-5-3", gnScatterPlot3)
        MakeDataSet(0, 100, 10, 100, 0.3, "BNMK-0", gnScatterPlot3)
        MakeDataSet(70, 100, 40, 100, 1.2, "MKL-09-87", gnScatterPlot3)
        gnScatterPlot3.plotLabelX = "X: ZX-12-DF"
        gnScatterPlot3.plotLabelY = "Y: GGG-P_09-0"
        gnScatterPlot3.TurnOnPlot()
        
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
