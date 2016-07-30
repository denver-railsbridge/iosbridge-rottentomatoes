//
//  Downloader.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 9/12/15.
//  Copyright © 2015 MobileBridge. All rights reserved.
//

import Foundation

class Downloader {
    
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    private var downloaded = [NSURL : NSData]()
    
    func fetchDataForURL(downloadURL: NSURL, callback: (NSURL, NSData) -> Void) {
        // is already cached
        if let data = self.downloaded[downloadURL] {
            callback(downloadURL, data)
            return
        }
        
        // start downloading
        self.session.dataTaskWithURL(downloadURL) { (downloadedData, response, error) in
            guard let downloadedData = downloadedData else {
                fatalError("missing data")
            }
            guard let response = response as? NSHTTPURLResponse else {
                fatalError("missing response")
            }
            
            switch response.statusCode {
            case 200:
                self.downloaded[downloadURL] = downloadedData
                callback(downloadURL, downloadedData)
            default:
                fatalError("incorrect response: \(response.statusCode)")
            }
        }.resume()
    }
}
