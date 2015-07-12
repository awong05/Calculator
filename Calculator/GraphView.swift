import UIKit

class GraphView: UIView
{
    var origin: CGPoint?
    var scale: CGFloat?
    var drawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        drawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale!)
    }
}
