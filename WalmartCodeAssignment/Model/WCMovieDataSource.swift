//
//  WCMovieDataSource.swift
//  WalmartCodeAssignment
//
//  Created by Alfredo Alba on 3/7/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

import Foundation

final class  MCMovieDataSource {
    
    let processingQueue = OperationQueue()
    
    var movieResult : [WCMovie] = [WCMovie]()
    
    static let sharedInstance =  MCMovieDataSource()
    
    fileprivate init() {}
    
    func searchMovies(search:String, page:Int, completion: @escaping (_ results: [WCMovie]?, _ error : NSError?) -> Void) {
        
        MCMovieAPIClient.getMovieAPI(search: search, page: page) { (result, error) in
            
            if error == nil {
                
                var movieResultSearch : [WCMovie] = [WCMovie]()
                
                let moviesResult = result!["results"] as! [AnyObject]
                
                for element in moviesResult {
                    
                    let MyMovie = WCMovie()
                    
                    if let id = element["id"] as? Int {
                        MyMovie.movieID = id
                    }
                    if let poster = element["poster_path"] as? String {
                        MyMovie.movieImageURL = poster
                    }
                    if let title = element["title"] as? String {
                        MyMovie.movieTitle = title
                    }
                    if let rate = element["vote_average"] as? Double {
                        MyMovie.movieRate = rate
                    }
                    if let release = element["release_date"] as? String {
                        MyMovie.movieRelease = release
                    }
                    if let description = element["overview"] as? String {
                        MyMovie.movieDescription = description
                    }
                    
                    movieResultSearch.append(MyMovie)
                }
                
                self.movieResult = movieResultSearch
                
                OperationQueue.main.addOperation({
                    
                    completion(movieResultSearch, nil)
                })
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    func changePageMovies(search:String, page:Int, completion: @escaping (_ results: [WCMovie]?, _ error : NSError?) -> Void) {
        
        MCMovieAPIClient.getMovieAPI(search: search, page: page) { (result, error) in
            
            if error == nil {
                
                let moviesResult = result!["results"] as! [AnyObject]
                
                for element in moviesResult {
                    
                    let MyMovie = WCMovie()
                    
                    if let id = element["id"] as? Int {
                        MyMovie.movieID = id
                    }
                    if let poster = element["poster_path"] as? String {
                        MyMovie.movieImageURL = poster
                    }
                    if let title = element["title"] as? String {
                        MyMovie.movieTitle = title
                    }
                    if let rate = element["vote_average"] as? Double {
                        MyMovie.movieRate = rate
                    }
                    if let release = element["release_date"] as? String {
                        MyMovie.movieRelease = release
                    }
                    if let description = element["overview"] as? String {
                        MyMovie.movieDescription = description
                    }
                    
                    self.movieResult.append(MyMovie)
                }
                
                OperationQueue.main.addOperation({
                    completion(self.movieResult, nil)
                })
            } else {
                completion(nil, error)
            }
            
        }
    }
}
