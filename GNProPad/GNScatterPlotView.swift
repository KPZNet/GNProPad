//
//  GNScatterPlotView.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/3/21.
//

import UIKit

class GNScatterPlotView: GNBaseView {

    var drawMarkOne : Bool = false
    
    override func draw(_ rect: CGRect)
    {
        SetScales()
        self.layer.sublayers = nil
            if(drawMarkOne)
            {
                DrawPlot1()
            }
        ReleaseScales()
    }
    
    func DrawPlotOne()
    {
        drawMarkOne = true
        
    }
    
    func DrawPlot1()
    {
        let center = CGPoint(x: 0 , y: 0)
        super.DrawMark(Mark: center)
    }

}
