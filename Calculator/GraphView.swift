import UIKit

class GraphView: UIView
{
    var origin: CGPoint?
    var scale: CGFloat {
        return 16.0
    }
    var drawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        origin = superview?.center
        drawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
    }
}