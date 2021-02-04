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
                super.DrawMark()
            }
        ReleaseScales()
    }
    
    override func DrawMark()
    {
        drawMarkOne = true
        
    }

}
