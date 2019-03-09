//
//  Support.swift
//  HeadyMovie
//
//  Created by Shailendra Barewar on 09/03/19.
//  Copyright © 2019 Shailendra. All rights reserved.
//

import UIKit

class Support: NSObject {
    
    func searchMovie(sortType: String) -> String{
        switch sortType {
        case "Popular":
            return "popular"
        case "Top Rated":
            return "top_rated"
        default:
            print("wrong choice")
        }
        return ""
    }
    func showMovieImage(imageView : UIImageView , path: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: path)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                
                imageView.image = image
            })
            
        }).resume()
    }
}
