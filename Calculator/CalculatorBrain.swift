import Foundation

class CalculatorBrain
{
    private enum Op: Printable
    {
        case Operand(Double)
        case Variable(String)
        case Constant(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let variable):
                    return variable
                case .Constant(let constant):
                    return constant
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
        
        var precedence: Int {
            get {
                switch self {
                case .BinaryOperation(let symbol, _):
                    switch symbol {
                    case "×", "÷":
                        return 150
                    case "+", "−":
                        return 100
                    default:
                        return Int.max
                    }
                default:
                    return Int.max
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    var description: String {
        var (result, remainder) = description(opStack)
        while !remainder.isEmpty {
            let (prevResult, prevRemainder) = description(remainder)
            result = prevResult + "," + result
            remainder = prevRemainder
        }
        return result
    }
    
    init() {
        /*
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        */
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.Constant("π")
    }
    
    // TODO: Parentheses is imperfect on final example - otherwise, good.
    private func description(ops: [Op]) -> (result: String, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .Constant(let constant):
                return (constant, remainingOps)
            case .UnaryOperation(let operation, _):
                let operandEvaluation = description(remainingOps)
                return (operation + "(\(operandEvaluation.result))", operandEvaluation.remainingOps)
            case .BinaryOperation(let symbol, let function):
                var op1Evaluation = description(remainingOps)
                var op2Evaluation = description(op1Evaluation.remainingOps)
                if Op.BinaryOperation(symbol, function).precedence > 100 {
                    if op1Evaluation.result.rangeOfString("+") != nil || op1Evaluation.result.rangeOfString("-") != nil {
                        op1Evaluation.result = "(" + op1Evaluation.result + ")"
                    
                    }
                    if op2Evaluation.result.rangeOfString("+") != nil || op2Evaluation.result.rangeOfString("-") != nil {
                        op2Evaluation.result = "(" + op2Evaluation.result + ")"
                        
                    }
                }
                return (op2Evaluation.result + symbol + op1Evaluation.result, op2Evaluation.remainingOps)
            }
        }
        return ("?", ops)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                if let variableValue = variableValues[variable] {
                    return (variableValue, remainingOps)
                } else {
                    return (nil, ops)
                }
            case .Constant(let constant):
                switch constant {
                    case "π":
                        let constantValue = M_PI
                        return (constantValue, remainingOps)
                    default:
                        return (nil, remainingOps)
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll()
    }
}