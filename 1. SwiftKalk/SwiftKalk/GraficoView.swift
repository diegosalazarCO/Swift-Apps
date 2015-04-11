//
//  GraficoView.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 4/10/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

protocol GraficoViewFuenteDatos: class {
    func y(x: CGFloat) -> CGFloat?
}

class GraficoView: UIView {
    
    weak var fuenteDatos: GraficoViewFuenteDatos?
    
    var anchoLinea: CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }
    var color: UIColor = UIColor(red: 82, green: 237, blue: 199, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
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
        color.set()
        let path = UIBezierPath()
        path.lineWidth = anchoLinea
        var primerValor = true
        var punto = CGPoint()
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            punto.x = CGFloat(i) / contentScaleFactor
            if let y = fuenteDatos?.y((punto.x - origen.x) / escala) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                punto.y = origen.y - y * escala
                if primerValor {
                    path.moveToPoint(punto)
                    primerValor = false
                } else {
                    path.addLineToPoint(punto)
                }
            }
        }
        path.stroke()
    }
}
