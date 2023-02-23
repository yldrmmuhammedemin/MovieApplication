//
//  TrendingTV.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import Foundation


struct TrendingTvResponse:Codable{
    let results: [Tv]
}

struct Tv: Codable{
    let id: Int
    let media_type: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_data: String?
    let vote_average: Double?
}


/*
 "adult":false,
    "backdrop_path":"/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg",
    "id":100088,
    "name":"The Last of Us",
    "original_language":"en",
    "original_name":"The Last of Us",
    "overview":"Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.",
    "poster_path":"/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg",
    "media_type":"tv",
    "genre_ids":[
       18,
       10759
    ],
    "popularity":5116.709,
    "first_air_date":"2023-01-15",
    "vote_average":8.815,
    "vote_count":1698,
    "origin_country":[
       "US"
    ]
 */
