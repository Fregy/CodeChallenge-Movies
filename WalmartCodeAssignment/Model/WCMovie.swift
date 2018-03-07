//
//  WCMovie.swift
//  WalmartCodeAssignment
//
//  Created by Alfredo Alba on 3/7/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

import Foundation

class WCMovie {
    //MARK: Properties
    
    var movieTitle : String
    var movieRate : Double
    var movieDescription : String
    var movieRelease : String
    var movieImageURL : String
    var movieID: Int
    
    //MARK: Initialization
    
    init() {
        self.movieTitle = ""
        self.movieRate  = 0.0
        self.movieDescription = ""
        self.movieRelease  = ""
        self.movieImageURL = ""
        self.movieID = 0
    }
}
