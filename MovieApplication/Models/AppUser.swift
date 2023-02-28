//
//  NetflixUser.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import Foundation
import Firebase

struct AppUser : Codable{
    let id : String
    var displayName : String = ""
    var username : String = ""
    var avatarPath : String = ""
    var isUserOnboarded : Bool = false
    var favoriteMovies : [TitlePreviewViewModel] = [TitlePreviewViewModel]()
        
    init(from user: User){
        self.id = user.uid
    }
    
}
