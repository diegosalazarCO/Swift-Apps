//
//  ViewController.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 3/16/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class CalculadoraViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var displayHistoria: UILabel!
    
    var usuarioEstaDigitandoNumero = false
    
    private var cerebro = CerebroCalculadora()
    
    @IBAction func añadirDigito(mensajero: UIButton) {
        
        let digito = mensajero.currentTitle!
        
        if usuarioEstaDigitandoNumero {
            if (digito == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            if (display.text!.rangeOfString(".") != nil) && digito == "."  { return}
            if (digito != ".") && ((display.text == "0") || (display.text == "-0")) {
                if (display.text == "0") {
                    display.text = digito
                } else {
                    display.text = "-" + digito
                }
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
            displayHistoria.text = cerebro.descripcion != "?" ? cerebro.descripcion : " "
        }
        
    }
    
    @IBAction func operar(mensajero: UIButton) {
        if let operacion = mensajero.currentTitle{
            if usuarioEstaDigitandoNumero {
                if operacion == "±" {
                    let textoDisplay = display.text!
                    if (textoDisplay.rangeOfString("-") != nil){
                        display.text = dropFirst(textoDisplay)
                    } else {
                        display.text = "-" + textoDisplay
                    }
                    return
                }
                enter()
            }
            if let resultado = cerebro.hacerOperacion(operacion){
                valorDisplay = resultado
                
            } else {
                valorDisplay = nil
            }
        }
    }
    
    @IBAction func enter() {
        usuarioEstaDigitandoNumero = false
        if let resultado = cerebro.pushOperando(valorDisplay!){
            valorDisplay = resultado
        } else {
            valorDisplay = nil
            displayHistoria.text = " "
        }
    }
    
    @IBAction func guardarVariable(mensajero: UIButton) {
        if let variable = last(mensajero.currentTitle!) {
            if valorDisplay != nil {
                cerebro.valoresVariable["\(variable)"] = valorDisplay
                if let resultado = cerebro.evaluar() {
                    valorDisplay = resultado
                } else {
                    valorDisplay = nil
                }
            }
        }
        usuarioEstaDigitandoNumero = false
    }
    
    @IBAction func pushVariable(mensajero: UIButton) {
        if usuarioEstaDigitandoNumero {
            enter()
        }
        if let resultado = cerebro.pushOperando(mensajero.currentTitle!) {
            valorDisplay = resultado
        } else {
            valorDisplay = nil
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
                if (countElements(textoDisplay) == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "-0"
                }
            } else {
                display.text = "0"
            }
        }
    }
    
    var valorDisplay: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil){
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            displayHistoria.text = cerebro.descripcion + " ="
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destino = segue.destinationViewController as? UIViewController
        if let navController = destino as? UINavigationController {
            destino = navController.visibleViewController
        }
        if let graficoVC = destino as? GraficoViewController {
            if let identificador = segue.identifier {
                switch identificador {
                    case "Grafico Segue":
                        graficoVC.title = cerebro.descripcion == "" ? "Gráfico" : cerebro.descripcion.componentsSeparatedByString(", ").last
                        graficoVC.programa = cerebro.programa
                    default: break
                }
            }
        }
    }
}
