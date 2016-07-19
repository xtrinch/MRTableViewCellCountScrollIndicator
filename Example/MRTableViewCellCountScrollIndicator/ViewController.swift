import UIKit
import RestKit
import MRTableViewCellCountScrollIndicator

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var articles:[Article] = []
    var cellCounter:MRTableViewCellCountScrollIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        cellCounter = MRTableViewCellCountScrollIndicator(tableView: tableView)
        cellCounter!.scrollCountView.mainBackgroundColor = UIColor.blueColor()
        cellCounter!.opacity = 0.7
        cellCounter!.rightOffset = 0
        //cellCounter!.showCellScrollCount(false)
        requestData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: RestKit
    
    func requestData() {self.fetchArticlesFromContext()

        let requestPath:String = "/articles.json"
        RKObjectManager.sharedManager().getObjectsAtPath(requestPath,
                                                         parameters: nil,
                                                         success: {(RKObjectRequestOperation, RKMappingResult) in
                                                                print("success")
                                                            self.fetchArticlesFromContext()
                                                            },
                                                         failure: {(RKObjectRequestOperation, NSError) in
                                                                print("failure")
                                                            })
    }
    
    func fetchArticlesFromContext() {
        let context:NSManagedObjectContext = RKManagedObjectStore.defaultStore().mainQueueManagedObjectContext
        let fetchRequest:NSFetchRequest = NSFetchRequest(entityName: "ArticleList")
        
        let descriptor:NSSortDescriptor = NSSortDescriptor(key:"title", ascending: true)
        fetchRequest.sortDescriptors = [descriptor]
        
        let error:NSError
        var fetchedObjects:[AnyObject] = []
        do {
            fetchedObjects = try context.executeFetchRequest(fetchRequest)
        } catch {
            print("fetch error")
            return
        }
        
        guard let articleList:ArticleList = fetchedObjects.first as? ArticleList else {
            return
        }
        
        articles = articleList.articles!.allObjects as! [Article]
        cellCounter!.totalScrollCountNum = articles.count
        tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell")!
        let article = articles[indexPath.row]
        (cell as! ArticleTableViewCell).mainTitle.text = article.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("A row has been selected")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("end decelerating")
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.cellCounter!.scrollCountView.alpha = 0.0
            }, completion: nil)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("begindragging")
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.cellCounter!.scrollCountView.alpha = self.cellCounter!.opacity
        }, completion: nil)
    }
    
}

