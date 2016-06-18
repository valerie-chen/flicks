//
//  FlicksViewController.swift
//  flicks
//
//  Created by Valerie Chen on 6/15/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]!
    
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "44e0e72d2b5f36a3f66be78a96349c02"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,completionHandler: { (data, response, error) in
                                                                        
            // ... Use the new data to update the data source ...
            
                                                                        
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
                                                                        
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows errorView to appear above cells when necessary
        errorView.layer.zPosition = 3
        searchBar.layer.zPosition = 1
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "44e0e72d2b5f36a3f66be78a96349c02"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
            
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.tableView.reloadData()
                        }
                    self.errorView.hidden = true
                } else {
                    self.errorView.hidden = false
            }
        })
        task.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let releaseDate = movie["release_date"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.releaseDateLabel.text = "Released: \(releaseDate)"
        cell.posterView.setImageWithURL(imageURL!)
        
        //print("row \(indexPath.row)")
        return cell
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(dataDict: NSDictionary) -> Bool in
//            let title = dataDict["title"] as! String
//            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//        })
//    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredMovies = movies!.filter({(dataDict: NSDictionary) -> Bool in
                let title = dataDict["title"] as! String
                // If dataItem matches the searchText, return true to include it
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationViewController = segue.destinationViewController as! MovieDetailsViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        let movie = filteredMovies![indexPath!.row]
        destinationViewController.movie = movie
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
