//
//  YoutubeContent.swift
//  FilmApplication
//
//  Created by Yildirim on 17.02.2023.
//

import Foundation

struct YoutubeContent:Codable {
    let items: [VideoElement]
    
}

struct VideoElement: Codable{
    let id: IdVideoElement
}

struct IdVideoElement: Codable{
    let kind: String
    let videoId: String
}
