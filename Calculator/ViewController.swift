//
//  ViewController.swift
//  Calculator
//
//  Created by Andy Wong on 6/13/15.
//  Copyright (c) 2015 Propel Marketing. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            // Uses OR short-circuiting to efficiently check decimal conditions.
            if digit != "." || display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        // history.text = history.text! + " \(operation)"
        if let operation = sender.currentTitle {
            /* TODO: Move extra operations to model.
            switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0) }
            case "sin": performOperation { sin($0) }
            case "cos": performOperation { cos($0) }
            case "π": operandStack.append(M_PI)
            default: break
            }
            history.text = history.text! + " ="
            */
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            // operandStack.append(displayValue!)
            // history.text = history.text! + " \(displayValue!)"
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = 0
            }
        } else {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
        // println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clearEverything(sender: UIButton) {
        display.text = "0"
        history.text = ""
        // operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backspace(sender: UIButton) {
        if count(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func changeSign(sender: UIButton) {
        // TODO: Refactor this block to be more succinct.
        // Currently, uses one loop to check if user is in the middle of typing.
        // If true, function uses nested loop to check current sign, act accordingly.
        // Otherwise, treats button as normal unary operation.
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString("-") == nil {
                display.text!.insert("-", atIndex: display.text!.startIndex)
            } else {
                display.text!.removeAtIndex(display.text!.startIndex)
            }
        } // else {
            // performOperation { $0 * -1 }
        // }
    }
}