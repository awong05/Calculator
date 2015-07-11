import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
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
        if let operation = sender.currentTitle {
            if let newValue = brain.performOperation(operation) {
                displayValue = newValue
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
            if let newValue = brain.pushOperand(displayValue!) {
                displayValue = newValue
            } else {
                displayValue = 0
            }
        } else {
            display.text = "0"
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.description + "="
        }
    }
    
    @IBAction func clearEverything(sender: UIButton) {
        display.text = "0"
        history.text = " "
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
        if userIsInTheMiddleOfTypingANumber {
            if let _ = display.text!.rangeOfString("-") {
                display.text!.removeAtIndex(display.text!.startIndex)
            } else {
                display.text!.insert("-", atIndex: display.text!.startIndex)
            }
        } else {
            displayValue = -displayValue!
        }
    }
    
    @IBAction func setM(sender: UIButton) {
        if let value = displayValue {
            brain.variableValues["M"] = value
            let newValue = brain.evaluate()
            displayValue = newValue
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func getM(sender: UIButton) {
        enter()
        brain.pushM()
        brain.evaluate()
    }
}