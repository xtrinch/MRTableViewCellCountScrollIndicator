import Foundation
import UIKit

public class MRTableViewCellCountScrollIndicator:NSObject, UIScrollViewDelegate {

    public let scrollCountView = ScrollCountView()
    public var rightOffset:CGFloat = 8    
    public var tableView:UITableView
    public var scrollCountViewHeight:CGFloat = 20
    private var dragging:Bool = false
    
    
    public var opacity:CGFloat = 0.7 {
        didSet {
            scrollCountView.alpha = opacity
        }
    }
    
    public init(tableView:UITableView) {
        self.tableView = tableView
        tableView.addSubview(scrollCountView)
    }
    
    public func showCellScrollCount(animated:Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        self.tableView.addObserver(self, forKeyPath: "dragging", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath, object) {
            
        case (.Some("contentOffset"), _):
            self.updateScrollPosition()
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func updateScrollPosition() {
        
        let indexPaths = tableView.indexPathsForVisibleRows
        if let indexPaths = indexPaths {
            if indexPaths.count > 0 {
                scrollCountView.currentScrollCountNum = indexPaths[0].row
            }
        }
        
        let viewSize = tableView.bounds.size.height
        let tableContentHeight = tableView.contentSize.height
        let scrollLimit = tableContentHeight - viewSize
        let scrollOffset = tableView.contentOffset.y
        let scrollDelta = scrollOffset / scrollLimit
        
        //let trackerFrame = scrollCountView.frame
        let trackerTravel = viewSize - scrollCountViewHeight
        var trackerOffset = scrollOffset + (trackerTravel * scrollDelta)
        
        // dock tracker with tableView content end/start if bouncing
        if trackerOffset < 0 {
            trackerOffset = 0
        } else if (trackerOffset >= tableContentHeight - scrollCountViewHeight) {
            trackerOffset = tableContentHeight - scrollCountViewHeight
        }
        
        let width = scrollCountView.width
        scrollCountView.frame = CGRect(
            origin: CGPoint(
                x: tableView.bounds.size.width - width - rightOffset,
                y: trackerOffset
            ),
            size: CGSize(width: width, height: scrollCountViewHeight)
        )
    }
    
}