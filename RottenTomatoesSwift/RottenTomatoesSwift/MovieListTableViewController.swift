//
//  MovieListTableViewController.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/14/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    private var movies = [Movie]()
    private let downloader = Downloader()
    private let jsonURL: NSURL = {
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        return NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Top Movies"
        
        self.downloader.fetchDataForURL(self.jsonURL) { url, downloadedData in
            self.finishedDownloadingMovies(downloadedData)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! MovieTableViewCell
        
        let cellModel = movies[indexPath.row]
        cell.model = cellModel
        
        self.downloader.fetchDataForURL(cellModel.posterURL) { url, posterData in
            self.finishedDownloadingPosterData(posterData, forCell:cell)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieTableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    func finishedDownloadingMovies(downloadedData: NSData) {
        let json = try! NSJSONSerialization.JSONObjectWithData(downloadedData, options: .AllowFragments) as! NSDictionary
    
        let listOfMovieDescriptions = json["movies"] as! [NSDictionary]
        let listOfMovies = Movie.moviesFromMovieDescriptions(listOfMovieDescriptions)
        
        // Now update the UI, which can only be done from main thread
        dispatch_async(dispatch_get_main_queue()) {
            self.movies = listOfMovies ?? []
            self.tableView.reloadData()
        }
    }
    
    func finishedDownloadingPosterData(posterData: NSData, forCell cell: MovieTableViewCell) {
        let image = UIImage(data: posterData)!

        // Now update the UI, which can only be done from main thread
        dispatch_async(dispatch_get_main_queue()) {
            cell.updateDisplayImages(image)
        }
    }
}

