//
//  MovieDetailsViewController.swift
//  flicks
//
//  Created by Valerie Chen on 6/17/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieHeader: UINavigationItem!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: NSDictionary = [:]
    var genreDict: [Int:String] = [
        28 : "Action",
        12 : "Adventure",
        16 : "Animation",
        35 : "Comedy",
        80 : "Crime",
        99 : "Documentary",
        18 : "Drama",
        10751 : "Family",
        14 : "Fantasy",
        10769: "Foreign",
        36: "History",
        27 : "Horror",
        10402 : "Music",
        9648 : "Mystery",
        10749 : "Romance",
        878 : "Science Fiction",
        10770 : "TV Movie",
        53 : "Thriller",
        10752 : "War",
        37 : "Western"
    ]

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let releaseDate = movie["release_date"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        let imageURL = NSURL(string: baseURL + posterPath)
        let genreIDs = movie["genre_ids"] as! [Int]
        
        var genres = ""
        for genreID in genreIDs {
            genres = genres + genreDict[genreID]!
            genres = genres + ", "
        }
        genres.removeAtIndex(genres.endIndex.predecessor())
        genres.removeAtIndex(genres.endIndex.predecessor())
        
        backgroundImageView.setImageWithURL(imageURL!)
        //self.view.backgroundColor = UIColor(patternImage: posterView.image!)
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        backgroundImageView.addSubview(blurEffectView)
        
        titleLabel.text = title
        overviewLabel.text = overview
        releaseDateLabel.text = "Released: \(releaseDate)"
        posterView.setImageWithURL(imageURL!)
        genresLabel.text = genres

        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
