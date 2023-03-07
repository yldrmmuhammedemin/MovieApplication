//
//  FavoriteMovies.swift
//  MovieApplication
//
//  Created by Yildirim on 2.03.2023.
//

import Foundation
import Firebase

struct FavoriteMovies: Codable{
    let id : String
    var favoriteMovies : [TitlePreviewViewModel] = [TitlePreviewViewModel]()
    
    init(from id : String){
        self.id = id
    }
}
