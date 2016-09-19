import Foundation
import UIKit

public class MRTableViewCellCountScrollIndicator:NSObject, UIScrollViewDelegate {
    
    public let scrollCountView = ScrollCountView()
    public var rightOffset:CGFloat = 8
    public weak var tableView:UITableView!
    public var scrollCountViewHeight:CGFloat = 20
    private var dragging:Bool = false
    private var dynamicUnpagedHeight:Bool = false
    var y:CGFloat = -1000
    private var topConstraint : NSLayoutConstraint!
    
    public var opacity:CGFloat = 1 {
        didSet {
            scrollCountView.alpha = opacity
        }
    }
    
    public var totalScrollCountNum = 0 {
        didSet {
            scrollCountView.totalScrollCountNum = totalScrollCountNum
        }
    }
    
    deinit {
        self.tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    public init(tableView:UITableView) {
        self.tableView = tableView
        tableView.layoutIfNeeded()
        super.init()
        scrollCountView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(scrollCountView)
        
        var rightConstraint: NSLayoutConstraint!
        var heightConstraint: NSLayoutConstraint!
        
        
        topConstraint = NSLayoutConstraint(item: scrollCountView, attribute: .Top, relatedBy: .Equal, toItem: (tableView), attribute: .Top, multiplier: 1, constant: 0)
        tableView.addConstraint(topConstraint)
        
        heightConstraint = NSLayoutConstraint(item: scrollCountView, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: scrollCountViewHeight)
        tableView.addConstraint(heightConstraint)
        
        rightConstraint = NSLayoutConstraint(item: scrollCountView, attribute: .Trailing, relatedBy: .Equal, toItem: tableView, attribute: .Leading, multiplier: 1, constant: tableView.contentSize.width)
        tableView.addConstraint(rightConstraint)
        showCellScrollCount(false)
    }
    
    public func showCellScrollCount(animated:Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath, object) {
            
        case (.Some("contentOffset"), _):
            if y != tableView.contentOffset.y && totalScrollCountNum != 0 {
                y = tableView.contentOffset.y
                self.updateScrollPosition()
            }
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func updateScrollPosition() {
        
        //var currentCellRect:CGRect?
        let indexPaths = tableView.indexPathsForVisibleRows
        var currentCellRect:CGRect?
        if let indexPaths = indexPaths {
            if indexPaths.count > 0 {
                currentCellRect = tableView.rectForRowAtIndexPath(indexPaths[0])
                scrollCountView.currentScrollCountNum = indexPaths[0].row
            }
        }
        
        
        guard let currentCellRectu = currentCellRect else {
            return
        }
        
        if (dynamicUnpagedHeight) {
            
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
        } else {
            if totalScrollCountNum == 0 {
                return
            }
            
            let oneDistance = tableView.bounds.size.height / CGFloat(totalScrollCountNum)
            let currentCellHeight = currentCellRectu.size.height
            let currentCellOffset = currentCellRectu.origin.y
            let currentOffset = tableView.contentOffset.y
            
            let dxp = (currentOffset - currentCellOffset)/currentCellHeight
            let dx = dxp * oneDistance
            
            var finalY = tableView.contentOffset.y + ((tableView.bounds.size.height*CGFloat(scrollCountView.currentScrollCountNum)) / CGFloat(totalScrollCountNum)) + dx
            
            if (finalY < 0) {
                finalY = 0
            } else if(finalY > tableView.contentSize.height - scrollCountViewHeight) {
                finalY = tableView.contentSize.height - scrollCountViewHeight
            }
            
            topConstraint.constant = finalY
        }
    }
    
}
