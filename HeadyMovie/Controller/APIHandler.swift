//
//  APIHandler.swift
//  HeadyMovie
//
//  Created by Shailendra Barewar on 07/03/19.
//  Copyright © 2019 Shailendra. All rights reserved.
//

import Foundation

 class AppConstants
{
    let apiKey = "2fc0a54f2813045c20d6117765e9c0dd"
    
    func baseURL() -> String {
        return "https://api.themoviedb.org/3/movie/"
    }
    func imageURL() -> String{
        return "https://image.tmdb.org/t/p/w500/"
    }
    
}
