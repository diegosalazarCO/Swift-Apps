//
//  CerebroCalculadora.swift
//  SwiftKalk
//
//  Created by Diego Salazar on 3/19/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import Foundation

class CerebroCalculadora {
    
    private enum Op: Printable {
        case Operando(Double)
        case OperacionUnitaria ( String, Double -> Double )
        case OperacionBinaria( String, ( Double, Double ) -> Double )
        
        var description: String{
            get {
                switch self {
                case .Operando(let operando):
                    return "\(operando)"
                case .OperacionUnitaria(let simbolo, _):
                    return "\(simbolo)"
                case .OperacionBinaria(let simbolo, _):
                    return "\(simbolo)"
                }
            }
        }
    }
    
    private var stackOp = [Op]()
    private var operaciones = [String:Op]()
    
    init() {
        func aprenderOperacion(op: Op){
            operaciones[op.description] = op
        }
        
        aprenderOperacion(Op.OperacionBinaria("÷") {$1 / $0})
        aprenderOperacion(Op.OperacionBinaria("×", *))
        aprenderOperacion(Op.OperacionBinaria("−") {$1 - $0})
        aprenderOperacion(Op.OperacionBinaria("+", +))
        aprenderOperacion(Op.OperacionUnitaria("√", sqrt))
        aprenderOperacion(Op.OperacionUnitaria("sin", sin))
        aprenderOperacion(Op.OperacionUnitaria("cos", cos))
    }
    
    private func evaluar(ops: [Op])->(resultado: Double?, opsRestantes: [Op]) {
        if !ops.isEmpty {
            // crear copia de ops para poder mutar arreglo
            var opsRestantes = ops
            let op = opsRestantes.removeLast()
            switch op {
            case .Operando(let operando):
                return (operando, opsRestantes)
            case .OperacionUnitaria(_, let operacion): // _ significa No importa el nombre
                let evaluacionOperando = evaluar(opsRestantes)
                if let operando = evaluacionOperando.resultado{
                    return (operacion(operando), evaluacionOperando.opsRestantes)
                }
            case .OperacionBinaria(_, (let operacion)):
                let op1Evaluacion = evaluar(opsRestantes)
                if let operando1 = op1Evaluacion.resultado{
                    let op2Evaluacion = evaluar(op1Evaluacion.opsRestantes)
                    if let operando2 = op2Evaluacion.resultado{
                        return (operacion(operando1, operando2), op1Evaluacion.opsRestantes)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluar()->Double? {
        let (resultado, restante) = evaluar(stackOp)
        println("\(stackOp) = \(resultado) con \(restante) restantes")
        return resultado
    }
    
    func pushOperando(operando: Double)->Double? {
        stackOp.append(Op.Operando(operando))
        return evaluar()
    }
    
    func hacerOperacion(simbolo: String)->Double? {
        if let operacion = operaciones[simbolo] {
            stackOp.append(operacion)
        }
        return evaluar()
    }
    
}