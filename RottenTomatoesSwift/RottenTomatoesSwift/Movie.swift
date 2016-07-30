//
//  Movie.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 9/12/15.
//  Copyright © 2015 MobileBridge. All rights reserved.
//

import Foundation

struct Movie {
    let title: String
    let description: String
    let posterURL: NSURL
}

extension Movie {
    static func moviesFromMovieDescriptions(listOfMovieDescriptions: [NSDictionary]) -> [Movie]? {
        var movies = [Movie]()
        
        for movieDescription in listOfMovieDescriptions {
            guard let posterDictionary = movieDescription["posters"] as? NSDictionary,
                  let posterURLString = posterDictionary["thumbnail"] as? String,
                  let posterURL = NSURL(string: posterURLString) else {
                continue
            }
                    
            let movieTitle = movieDescription["title"] as? String ?? "Title Not Found"
            let description = movieDescription["synopsis"] as? String ?? "Synopsis Not Found"
            
            movies.append(Movie(title: movieTitle, description: description, posterURL: posterURL))
        }
        
        return movies
    }
}









