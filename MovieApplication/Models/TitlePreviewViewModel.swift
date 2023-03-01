//
//  File.swift
//  FilmApplication
//
//  Created by Yildirim on 17.02.2023.
//

import Foundation
struct TitlePreviewViewModel:Codable, Equatable{
    let id : Int
    let title: String
    let youtubeView: VideoElement
    let titleOverView: String
    let posterPath: String
    
    static func == (lhs: TitlePreviewViewModel, rhs: TitlePreviewViewModel) -> Bool{
        return lhs.id == rhs.id
    }
}
