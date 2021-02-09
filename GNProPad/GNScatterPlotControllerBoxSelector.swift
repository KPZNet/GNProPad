//
//  GNScatterPlotControllerBoxSelector.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/9/21.
//

import Foundation
import UIKit
import GameplayKit

extension GNProMainViewViewController {
    

    func SetupSelectionBox() {
        // Do any additional setup after loading the view.
        overlay.layer.borderColor = UIColor.black.cgColor
        overlay.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        overlay.isHidden = true
        self.view.addSubview(overlay)
    }
    
    func reDrawSelectionArea(fromPoint: CGPoint, toPoint: CGPoint) {
        
        overlay.isHidden = false

        //Calculate rect from the original point and last known point
        let rect = CGRect(x:min(fromPoint.x, toPoint.x),
                          y:min(fromPoint.y, toPoint.y),
                          width:abs(fromPoint.x - toPoint.x),
                          height:abs(fromPoint.y - toPoint.y));

        overlay.frame = rect
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //Save original tap Point
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //Get the current known point and redraw
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            reDrawSelectionArea(fromPoint: lastPoint, toPoint: currentPoint)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        overlay.isHidden = true

        //User has lift his finger, use the rect
        //applyFilterToSelectedArea(overlay.frame)

        overlay.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
}
