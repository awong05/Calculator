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
            // TODO: This operation needs to be refactored to the model, here for now.
            if operation == "π" {
                brain.pushOperand(M_PI)
            }
            // history.text = history.text! + " ="
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
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
        brain.clearStack()
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
        // TODO: Refactor this entire block to be more succinct.
        // Currently, uses one loop to check if user is in the middle of typing.
        // If true, function uses nested loop to check current sign, act accordingly.
        // Otherwise, treats button as normal unary operation.
        if userIsInTheMiddleOfTypingANumber {
            if let _ = display.text!.rangeOfString("-") {
                display.text!.removeAtIndex(display.text!.startIndex)
            } else {
                display.text!.insert("-", atIndex: display.text!.startIndex)
            }
        } // else {
            // performOperation { $0 * -1 }
            // TODO: Not working as expected when user is not in the middle of typing.
            // brain.performOperation("ᐩ/-")
        // }
    }
}