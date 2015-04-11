//
//  GraficoView.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 4/10/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class GraficoView: UIView {
    
    var escala: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var origen: CGPoint = CGPoint() {
        didSet {
            resetearOrigen = false
            setNeedsDisplay()
        }
    }
    private var resetearOrigen: Bool = true {
        didSet {
            if resetearOrigen {
                setNeedsDisplay()
            }
        }
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        AxesDrawer(contentScaleFactor: contentScaleFactor)
        .drawAxesInRect(bounds, origin: origen, pointsPerUnit: escala)
    }
}
