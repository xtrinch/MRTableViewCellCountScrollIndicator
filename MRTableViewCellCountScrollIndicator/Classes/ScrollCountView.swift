import Foundation
import UIKit

public class ScrollCountView: NibLoadingView {
    
    @IBOutlet var bottomTriangle: BottomTriangle!
    @IBOutlet var topTriangle: TopTriangle!
    @IBOutlet var mainView: UIView!
    @IBOutlet var currentScrollCount: UILabel!
    @IBOutlet var totalScrollCount: UILabel!
    @IBOutlet weak var slash: UILabel!
    
    public var currentScrollCountNum = 1 {
        didSet {
            currentScrollCount.text = "\(currentScrollCountNum + 1)"
        }
    }
    public var totalScrollCountNum = 0 {
        didSet {
            totalScrollCount.text = "\(totalScrollCountNum)"
        }
    }
    public var mainBackgroundColor:UIColor = UIColor.redColor() {
        didSet {
            mainView.backgroundColor = mainBackgroundColor
            bottomTriangle.triangleColor = mainBackgroundColor
            topTriangle.triangleColor = mainBackgroundColor
        }
    }
    
    public var width:CGFloat {
        // margins
        var width:CGFloat = 23
        width += currentScrollCount.intrinsicContentSize().width
        width += totalScrollCount.intrinsicContentSize().width
        width += slash.intrinsicContentSize().width
        
        return width
    }

    
    override public func layoutSubviews() {
        super.layoutSubviews()
         let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.TopLeft, .BottomLeft], cornerRadii: CGSizeMake(3, 3))
         let maskLayer = CAShapeLayer()
         maskLayer.frame = layer.bounds
         maskLayer.path = path.CGPath
         self.layer.mask = maskLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}