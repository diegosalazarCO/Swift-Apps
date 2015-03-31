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
    
    @IBOutlet weak var displayHistoria: UILabel!
    
    var usuarioEstaDigitandoNumero = false
    
    var cerebro = CerebroCalculadora()
    
    @IBAction func añadirDigito(mensajero: UIButton) {
        
        let digito = mensajero.currentTitle!
        
        if usuarioEstaDigitandoNumero {
            if (display.text!.rangeOfString(".") != nil) && digito == "."  {
            } else {
                display.text = display.text! + digito
            }
        } else {
            if digito == "."{
                display.text = "0."
            } else {
                display.text = digito
            }
            usuarioEstaDigitandoNumero = true
        }
        
    }
    
    @IBAction func operar(mensajero: UIButton) {
        if usuarioEstaDigitandoNumero{
            enter()
        }
        if let operacion = mensajero.currentTitle{
            if let resultado = cerebro.hacerOperacion(operacion){
                valorDisplay = resultado
                
            } else {
                // TODO: convertir valorDisplay un Optional
                // para que pueda ser nil
                valorDisplay = 0
            }
        }
        
    }
    

    @IBAction func enter() {
        usuarioEstaDigitandoNumero = false
        if let resultado = cerebro.pushOperando(valorDisplay){
            valorDisplay = resultado
        } else {
            // TODO: convertir valorDisplay un Optional
            // para que pueda ser nil
            valorDisplay = 0
            displayHistoria.text = " "
        }
    }

    @IBAction func limpiar(mensajero: UIButton) {
        cerebro.limpiarStack()
        display.text = "0"
        displayHistoria.text = " "
    }
    
    @IBAction func borrarDigito(mensajero: UIButton) {
        if usuarioEstaDigitandoNumero {
            let textoDisplay = display.text!
            if countElements(textoDisplay) > 1 {
                display.text = dropLast(textoDisplay)
            } else {
                display.text = "0"
            }
        }
    }
    
    var valorDisplay: Double {
        get {
            return (display.text! as NSString!).doubleValue
        }
        set {
            display.text = "\(newValue)"
            displayHistoria.text = cerebro.mostrarStack()
        }
    }
    

}

