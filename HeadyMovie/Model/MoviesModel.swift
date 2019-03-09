//
//  MoviesModel.swift
//  HeadyMovie
//
//  Created by Shailendra Barewar on 07/03/19.
//  Copyright © 2019 Shailendra. All rights reserved.
//

import Foundation

class MovieData {
    var page: Int = 0
    var total_results: Int = 0
    var total_pages: Int = 0
    var results : [Movie] = []
}



class Movie  {
    var vote_count : Int  = 0
    var id: Int = 0
    var video: Int = 0
    var vote_average: Float = 0
    var title: String = ""
    var popularity: Double = 0
    var poster_path: String = ""
    var original_language: String = ""
    var original_title: String = ""
    var genre_ids:[Int] = []
    var backdrop_path: String = ""
    var adult: String = ""
    var overview : String = ""
    var release_date: String = ""
}
