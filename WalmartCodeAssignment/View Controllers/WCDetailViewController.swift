//
//  WCDetailViewController.swift
//  WalmartCodeAssignment
//
//  Created by Alfredo Alba on 3/7/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

import UIKit

class WCDetailViewController: UIViewController {

    // MARK: MovieObject
    
    var myMovieSelected : WCMovie = WCMovie()
    
    // MARK: UIControls
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMovieSelected()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMovieSelected() {
        
        self.title =  self.myMovieSelected.movieTitle
        
        // Create URL from string
        let url = NSURL(string: "https://image.tmdb.org/t/p/w200" + myMovieSelected.movieImageURL)
        
        // Download task:
        let task = URLSession.shared.dataTask(with: url! as URL) { (responseData, responseUrl, error) -> Void in
            if let data = responseData {
                
                // Execute in thread
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
        
        // Run task
        task.resume()
        
        self.descriptionTextView.text = self.myMovieSelected.movieDescription
        self.rateLabel.text = String(self.myMovieSelected.movieRate)
        self.releaseLabel.text = self.myMovieSelected.movieRelease
    }
}
