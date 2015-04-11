//
//  GraficoViewController.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 4/11/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class GraficoViewController: UIViewController, GraficoViewFuenteDatos {
    
    private var cerebro = CerebroCalculadora()

    @IBOutlet weak var graficoView: GraficoView! {
        didSet {
            graficoView.fuenteDatos = self
        }
    }
    
    func y(x: CGFloat) -> CGFloat? {
        cerebro.valoresVariable["M"] = Double(x)
        if let y = cerebro.evaluar() {
            return CGFloat(y)
        }
        return nil
    }
    
    typealias PropertyList = AnyObject
    
    var programa: PropertyList {
        get {
            return cerebro.programa
        }
        set {
            cerebro.programa = newValue
        }
    }

}
