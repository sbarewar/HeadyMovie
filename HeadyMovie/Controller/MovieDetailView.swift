//
//  MovieDetailView.swift
//  HeadyMovie
//
//  Created by Shailendra Barewar on 09/03/19.
//  Copyright © 2019 Shailendra. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailView: UIViewController {

    //Create Instance
    let support = Support()
    let appCons = AppConstants()
    
    @IBOutlet weak var posterView: UIImageView!
  
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    var movieDetail = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.setDataToView()
    }
    //MARK: - show data on view
    func setDataToView() {
        let path =  appCons.imageURL() + movieDetail.poster_path
        self.support.showMovieImage(imageView : posterView , path: path)
        self.originalTitle.text = movieDetail.original_title
        self.releaseDate.text = movieDetail.release_date
        self.detailTextView.text = movieDetail.overview
    
        self.rating.rating = Double(movieDetail.vote_average)
        self.rating.isUserInteractionEnabled = false
    }


}
