import UIKit

protocol GraphViewDataSource: class {}

class GraphView: UIView
{
    var origin: CGPoint?
    var scale: CGFloat {
        return 16.0
    }
    var drawer = AxesDrawer()
    
    weak var dataSource: GraphViewDataSource?
    
    override func drawRect(rect: CGRect) {
        origin = superview?.center
        drawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
    }
}