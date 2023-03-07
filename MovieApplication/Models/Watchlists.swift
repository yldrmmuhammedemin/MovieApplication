//
//  Watchlists.swift
//  MovieApplication
//
//  Created by Yildirim on 2.03.2023.
//

import Foundation
import Firebase

struct Watchlists : Codable{
    let id : String
    var watchlists : [TitlePreviewViewModel] = [TitlePreviewViewModel]()
    
    init(from id: String){
        self.id = id
    }
}
