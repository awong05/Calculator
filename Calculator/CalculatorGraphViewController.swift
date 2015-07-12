import UIKit

class CalculatorGraphViewController: UIViewController
{
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            // graphView.dataSource = self
        }
    }
}
