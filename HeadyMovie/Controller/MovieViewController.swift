//
//  MovieViewController.swift
//  HeadyMovie
//
//  Created by Shailendra Barewar on 07/03/19.
//  Copyright © 2019 Shailendra. All rights reserved.
//

import UIKit
import Alamofire

import BTNavigationDropdownMenu

class MovieViewController: UIViewController,UISearchResultsUpdating {
   
    @IBOutlet weak var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    var movies = MovieData()
    var filteredMovie = [Movie]()
    let support = Support()
    let appCons = AppConstants()
    var menuView: BTNavigationDropdownMenu!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchView()
        self.setUpCenterDropDown()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.getMovieList(baseURL: self.appCons.baseURL(), type: "popular")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
   
    //MARK: - set Dorpdown
    func setUpCenterDropDown() {
    let items = ["Popular", "Top Rated"]
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(0), items: items)
    
    menuView.cellHeight = 50
    menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
    menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
    menuView.shouldKeepSelectedCellColor = true
    menuView.cellTextLabelColor = UIColor.white
    menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
    menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
    menuView.arrowPadding = 15
    menuView.animationDuration = 0.5
    menuView.maskBackgroundColor = UIColor.black
    menuView.maskBackgroundOpacity = 0.3
    menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
    let type = self.support.searchMovie(sortType: items[indexPath])
    self.getMovieList(baseURL: self.appCons.baseURL(), type: type)
    }
    
    self.navigationItem.titleView = menuView
    }
    //MARK: - setup and Searching Movie by name
    func setupSearchView() {
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.green]
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.searchController = searchController
        // TextField Color Customization
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        definesPresentationContext = true
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredMovie.removeAll()
        filteredMovie = movies.results.filter({( movie : Movie) -> Bool in
            return movie.original_title.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK:- get movie list
    func getMovieList(baseURL: String , type: String) {
        
        let urlString = "\(baseURL)\(type)?api_key=\(self.appCons.apiKey)&language=en-US&page=1"
       
        self.movies.results.removeAll()
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Alamofire.request(urlString, method: .get, headers: nil)
            .responseJSON { response in
                activityIndicator.removeFromSuperview()
             
                guard let movieDist = response.result.value as? Dictionary<String, AnyObject> else {
                    print("responce found nil")
                    return
                }
                
                if let page = movieDist["page"] as? Int {
                    self.movies.page = page
                }
                if let total_results = movieDist["total_results"] as? Int {
                    self.movies.total_results = total_results
                }
                if let total_results = movieDist["total_results"] as? Int {
                    self.movies.total_results = total_results
                }
                
                if let total_pages = movieDist["total_pages"] as? Int {
                    self.movies.total_pages = total_pages
                }
                
                guard let movieList = movieDist["results"] as? Array<Any> else {
                    print("responce found nil")
                    return
                }
                for i in 0 ..< movieList.count {
                    guard let movieData = movieList[i] as? Dictionary<String , AnyObject> else {
                        print("Movie data not available")
                        return
                    }
                    let movie = Movie()
                    if let vote_count = movieData["vote_count"] as? Int {
                        movie.vote_count = vote_count
                    }
                    if let id = movieData["id"] as? Int {
                        movie.id = id
                    }
                    if let video = movieData["video"] as? Int {
                        movie.video = video
                    }
                    
                    if let vote_average = movieData["vote_average"] as? Float {
                        movie.vote_average = vote_average
                    }
                    if let title = movieData["title"] as? String {
                        movie.title = title
                    }
                    if let popularity = movieData["popularity"] as? Double {
                        movie.popularity = popularity
                    }
                    
                    if let poster_path = movieData["poster_path"] as? String {
                        movie.poster_path = poster_path
                    }
                    if let original_language = movieData["original_language"] as? String {
                        movie.original_language = original_language
                    }
                    if let original_title = movieData["original_title"] as? String {
                        movie.original_title = original_title
                    }
                    
                    if let genre_ids =  movieData["genre_ids"] as? [Int] {
                       movie.genre_ids = genre_ids
                    }
                    if let backdrop_path = movieData["backdrop_path"] as? String {
                        movie.backdrop_path = backdrop_path
                    }
                    if let adult = movieData["adult"] as? String {
                        movie.adult = adult
                    }
                    if let overview = movieData["overview"] as? String {
                        movie.overview = overview
                    }
                    if let release_date = movieData["release_date"] as? String {
                        movie.release_date = release_date
                    }
                    self.movies.results.append(movie)
                }
                self.collectionView.reloadData()
        }
    }
}
//MARK:- All collectionview methods
extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovie.count
        }else{
        return self.movies.results.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie : Movie
        if isFiltering() {
            movie = self.filteredMovie[indexPath.row]
        }else {
            movie = self.movies.results[indexPath.row]
        }
        cell.name.text = movie.original_title
        let imagePath = self.appCons.imageURL() + movie.poster_path
        self.support.showMovieImage(imageView: cell.poster, path: imagePath)
        return cell
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = movies.results[indexPath.row]
        // Safe Push VC
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailView") as? MovieDetailView {
            if let navigator = navigationController {
                viewController.movieDetail = data
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
