# MRTableViewCellCountScrollIndicator

[![CI Status](http://img.shields.io/travis/xtrinch/MRTableViewCellCountScrollIndicator.svg?style=flat)](https://travis-ci.org/xtrinch/MRTableViewCellCountScrollIndicator)
[![Version](https://img.shields.io/cocoapods/v/MRTableViewCellCountScrollIndicator.svg?style=flat)](http://cocoapods.org/pods/MRTableViewCellCountScrollIndicator)
[![License](https://img.shields.io/cocoapods/l/MRTableViewCellCountScrollIndicator.svg?style=flat)](http://cocoapods.org/pods/MRTableViewCellCountScrollIndicator)
[![Platform](https://img.shields.io/cocoapods/p/MRTableViewCellCountScrollIndicator.svg?style=flat)](http://cocoapods.org/pods/MRTableViewCellCountScrollIndicator)

Shows a simple UITableView scroll count indicator. Written in Swift 2.2.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<img src='https://raw.githubusercontent.com/xTrinch/MRTableViewCellCountScrollIndicator/master/Graphics/screencap.gif' alt='Moving content from under the keyboard in iOS / Swift'>

## Usage

Create a MRTableViewCellCountScrollIndicator class, initialize it with your tableView. There are some variables in the class like color, height, opacity, alpha that you could change, or leave them at default values. Your ViewController remains the delegate and dataSource for the tableView, so all you have to make sure is to set the correct number of items after you fetch them from your API.

For fadeout see example project.


	import MRTableViewCellCountScrollIndicator
	
	class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	    @IBOutlet weak var tableView: UITableView!
	    var articles:[Article] = []
	    var cellCounter:MRTableViewCellCountScrollIndicator?
	    
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        tableView.delegate = self
	        tableView.dataSource = self
	        tableView.rowHeight = UITableViewAutomaticDimension
	        cellCounter = MRTableViewCellCountScrollIndicator(tableView: tableView)
	        cellCounter!.scrollCountView.mainBackgroundColor = UIColor.blueColor()
	        cellCounter!.opacity = 0.7
	        fetchDataFromApi()
	    }
	    
	    func fetchDataFromApi() {
	      // fetch data
	      cellCounter!.scrollCountView.totalScrollCountNum = articles.count
	      tableView.reloadData()
	    }
	}

## Installation

MRTableViewCellCountScrollIndicator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MRTableViewCellCountScrollIndicator"
```

## Author

xTrinch, mojca.rojko@gmail.com

## License

MRTableViewCellCountScrollIndicator is available under the MIT license. See the LICENSE file for more info.
