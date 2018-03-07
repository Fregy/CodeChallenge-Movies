//
//  WCMainViewController.swift
//  WalmartCodeAssignment
//
//  Created by Alfredo Alba on 3/7/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

import UIKit

class WCMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Properties
    
    private let reuseIdentifier = "movieCellIdentifier"
    private let movieClient = MCMovieDataSource.sharedInstance
    private var movieResult : [WCMovie] = [WCMovie]()
    private var page : Int = Int()
    private var bottomFlag = false
    
    // MARK: Control
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register cell classes
        self.movieTableView.register(UINib(nibName: "WCMovieTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Search Textfield Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.page = 1
        
        movieClient.searchMovies(search: searchBar.text!, page: self.page) { (results, error) in
            if error == nil {
                self.movieResult = results!
                self.movieTableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Not Found",
                                              message: "Try another Movie",
                                              preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            self.movieSearchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieResult.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = self.movieTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WCMovieTableViewCell
     
        cell.movieTitleLabel.text = (self.movieResult[indexPath.row] as WCMovie).movieTitle
        cell.movieImageView.image = UIImage(named: "filmImage")
     
        // Create URL from string
        let url = NSURL(string: "https://image.tmdb.org/t/p/w200" + (self.movieResult[indexPath.row] as WCMovie).movieImageURL)!
        
        // Download task:
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            if let data = responseData {
                
                // Execute in thread
                DispatchQueue.main.async {
                    cell.movieImageView.image = UIImage(data: data)
                }
            }
        }
        
        // Run task
        task.resume()
     
     return cell
     }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showMovieDetails", sender: indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMovieDetails") {
            let viewController = segue.destination as! WCDetailViewController
            let indexPath = (sender as! NSIndexPath);
            
            viewController.myMovieSelected = self.movieResult[indexPath.row]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            
            if self.bottomFlag == false {
                self.bottomFlag = true
                self.page += 1
                
                movieClient.changePageMovies(search: self.movieSearchBar.text!, page: self.page) { (results, error) in
                    if error == nil {
                        self.movieResult = results!
                        self.movieTableView.reloadData()
                    } else {
                        print("No more Pages")
                    }
                    
                    self.bottomFlag = false
                }
            }
            
        }
    }

}
