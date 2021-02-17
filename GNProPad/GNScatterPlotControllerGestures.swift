//
//  GNScatterPlotControllerGestures.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/8/21.
//

import Foundation
import UIKit

extension GNProMainViewViewController {
    

    // MARK: Handle Gesture detection
    @objc func swipeGetstureDetected() {
        //print("Swipe Gesture detected!!")
    }

    @objc func tapGetstureDetected() {
        LoadPlotSimulations()
    }

    @objc func pinchGetstureDetected() {
       
    }

    @objc func longPressGetstureDetected() {
        
    }

    @objc func doubleTapGestureDetected() {
        
    }

    @objc func panGestureDetected() {
        
    }
    
    func addGestures()
    {
        // 1. Single Tap or Touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGetstureDetected))
        tapGesture.numberOfTapsRequired = 1
        plotC.addGestureRecognizer(tapGesture)

        //2. Double Tap
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureDetected))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        plotC.addGestureRecognizer(doubleTapGesture)

        //3. Swipe
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGetstureDetected))
        plotC.addGestureRecognizer(swipeGesture)

        //4. Pinch
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGetstureDetected))
        plotC.addGestureRecognizer(pinchGesture)

        //5. Long Press
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGetstureDetected))
        plotC.addGestureRecognizer(longPressGesture)

        //6. Pan
        let panGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.panGestureDetected))
        plotC.addGestureRecognizer(panGesture)

    }
    
}
