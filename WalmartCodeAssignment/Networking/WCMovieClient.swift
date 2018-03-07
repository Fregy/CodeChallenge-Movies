//
//  WCMovieClient.swift
//  WalmartCodeAssignment
//
//  Created by Alfredo Alba on 3/7/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

import Foundation

let kMovieURL = "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page="
let kMovieAPIKey = "3ba6b50e7e5e5e6529299e911d4c4468"

typealias movieJSON = [String: AnyObject]

struct MCMovieAPIClient {
    
    static func getMovieAPI(search:String, page:Int, _ completion : @escaping (_ results: movieJSON?, _ error : NSError?) -> Void) {
        
        var urlFormatString = search.replacingOccurrences(of: " ", with: "+")
        
        urlFormatString = String(utf8String: urlFormatString.cString(using: .utf8)!)!
        
        let url = URL(string: kMovieURL + String(page) + "&api_key=" + kMovieAPIKey + "&query=" + urlFormatString)
        
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { print("Error unwrapping URL"); return }
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: url! ,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let dataTask = session.dataTask(with: unwrappedURL) { (data, response, error) in
            
            do {
                // checking we are getting the right information
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let _ = resultsDictionary["total_results"] as? Int64 else {
                        
                        let APIError = NSError(domain: "TMDB", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"The resource you requested could not be found."])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                
                
                completion(resultsDictionary , nil)
            } catch {
                print("Could not get data. \(error), \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
