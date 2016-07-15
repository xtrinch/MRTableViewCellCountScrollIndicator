import UIKit

public class BottomTriangle: UIView {

    public var triangleColor:UIColor = UIColor.redColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override public func drawRect(rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.moveToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, 0))
        bezierPath.addLineToPoint(CGPointMake(0, layerHeight))
        bezierPath.addLineToPoint(CGPointMake(0, 0))
        bezierPath.closePath()
        
        // Apply Color
        triangleColor.setFill()
        bezierPath.fill()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.CGPath
        self.layer.mask = shapeLayer
        
    }
    
}