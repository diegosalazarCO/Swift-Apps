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
        case OperacionNula(String, ()-> Double)
        case OperacionUnitaria( String, Double -> Double )
        case OperacionBinaria( String, ( Double, Double ) -> Double )
        case Variable(String)
        
        var description: String{
            get {
                switch self {
                case .Operando(let operando):
                    return "\(operando)"
                case .OperacionNula(let simbolo, _):
                    return "\(simbolo)"
                case .OperacionUnitaria(let simbolo, _):
                    return "\(simbolo)"
                case .OperacionBinaria(let simbolo, _):
                    return "\(simbolo)"
                case .Variable(let simbolo):
                    return "\(simbolo)"
                }
            }
        }
    }
    
    var programa: AnyObject {
        get {
//            var valorRetorno = [String]()
//            for op in stackOp {
//                valorRetorno.append(op.description)
//            }
//            return valorRetorno
            return stackOp.map{$0.description}
        }
        set {
            if let simbolosOp = newValue as? [String] {
                var nuevoStackOps = [Op]()
                let formatterNumero = NSNumberFormatter()
                for simbolo in simbolosOp {
                    if let op = operaciones[simbolo] {
                        nuevoStackOps.append(op)
                    } else if let operando = formatterNumero.numberFromString(simbolo)?.doubleValue {
                        nuevoStackOps.append(.Operando(operando))
                    }
                }
                stackOp = nuevoStackOps
            }
        }
    }
    
    var descripcion: String {
        get {
            var (resultado, ops) = ("", stackOp)
            do {
                var actual: String?
                (actual, ops) = descripcion(ops)
                resultado = resultado == "" ? actual! : "\(actual!), \(resultado)"
            } while ops.count > 0
            return resultado
        }
    }
    
    private func descripcion(ops: [Op]) -> (result: String?, opsRestantes: [Op]) {
        if !ops.isEmpty {
            var opsRestantes = ops
            let op = opsRestantes.removeLast()
            switch op {
            case .Operando(let operando):
                return (String(format: "%g", operando) , opsRestantes)
            case .OperacionNula(let simbolo, _):
                return (simbolo, opsRestantes);
            case .OperacionUnitaria(let simbolo, _):
                let evaluacionOperando = descripcion(opsRestantes)
                if let operando = evaluacionOperando.result {
                    return ("\(simbolo)(\(operando))", evaluacionOperando.opsRestantes)
                }
            case .OperacionBinaria(let simbolo, _):
                let evaluacionOp1 = descripcion(opsRestantes)
                if var operando1 = evaluacionOp1.result {
                    if opsRestantes.count - evaluacionOp1.opsRestantes.count > 2 {
                        operando1 = "(\(operando1))"
                    }
                    let evaluacionOp2 = descripcion(evaluacionOp1.opsRestantes)
                    if let operando2 = evaluacionOp2.result {
                        return ("\(operando2) \(simbolo) \(operando1)", evaluacionOp2.opsRestantes)
                    }
                }
            case .Variable(let simbolo):
                return (simbolo, opsRestantes)
            }
        }
        return ("?", ops)
    }
    
    private var stackOp = [Op]()
    private var operaciones = [String:Op]()
    var valoresVariable = [String: Double]()
    
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
        aprenderOperacion(Op.OperacionNula("π") { M_PI })
        aprenderOperacion(Op.OperacionUnitaria("±") { -$0 })
    }
    
    private func evaluar(ops: [Op])->(resultado: Double?, opsRestantes: [Op]) {
        if !ops.isEmpty {
            // crear copia de ops para poder mutar arreglo
            var opsRestantes = ops
            let op = opsRestantes.removeLast()
            switch op {
            case .Operando(let operando):
                return (operando, opsRestantes)
            case .OperacionNula(_, let operacion):
                return (operacion(), opsRestantes)
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
            case .Variable(let simbolo):
                return (valoresVariable[simbolo], opsRestantes)
            }
        }
        return (nil, ops)
    }
    
    func evaluar()->Double? {
        let (resultado, restante) = evaluar(stackOp)
        println("\(stackOp) = \(resultado) con \(restante) restantes")
        return resultado
    }
    
    func pushOperando(operando: Double) -> Double? {
        stackOp.append(Op.Operando(operando))
        return evaluar()
    }
    
    func pushOperando(simbolo: String) -> Double? {
        stackOp.append(Op.Variable(simbolo))
        return evaluar()
    }
    
    func hacerOperacion(simbolo: String)->Double? {
        if let operacion = operaciones[simbolo] {
            stackOp.append(operacion)
        }
        return evaluar()
    }
    
    func mostrarStack() -> String? {
        return " ".join(stackOp.map{ "\($0)" })
    }
    
    func limpiarStack(){
        stackOp = []
    }
    
}