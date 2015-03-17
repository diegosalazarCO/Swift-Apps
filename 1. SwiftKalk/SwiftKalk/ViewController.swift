//
//  ViewController.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 3/16/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var usuarioEstaDigitandoNumero = false
    
    @IBAction func añadirDigito(mensajero: UIButton) {
        
        let digito = mensajero.currentTitle!
        
        if usuarioEstaDigitandoNumero {
            display.text = display.text! + digito
        } else {
            display.text = digito
            usuarioEstaDigitandoNumero = true
        }
        
    }
    
    @IBAction func operar(mensajero: UIButton) {
        
        let operacion = mensajero.currentTitle!
        
        switch operacion {
            case "÷" : hacerOperacion { $1 / $0 }
            case "×" : hacerOperacion { $0 * $1 }
            case "−" : hacerOperacion { $1 - $0 }
            case "+" : hacerOperacion { $0 + $1 }
            case "√" : hacerOperacion { sqrt($0) }
            default:break
        }
    }
    
    func hacerOperacion (operacion: (Double,Double) ->Double) {
        if stackOperandos.count >= 2 {
            valorDisplay = operacion(stackOperandos.removeLast(), stackOperandos.removeLast())
            enter()
        }
        
    }
    
    func hacerOperacion (operacion: (Double) ->Double) {
        if stackOperandos.count >= 2 {
            valorDisplay = operacion(stackOperandos.removeLast())
            enter()
        }
        
    }
    
    var stackOperandos = [Double]()

    @IBAction func enter() {
        
        usuarioEstaDigitandoNumero = false
        stackOperandos.append(valorDisplay)
        println("Stack = \(stackOperandos)")
    }

    var valorDisplay: Double {
        get {
            return (display.text! as NSString!).doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    

}

