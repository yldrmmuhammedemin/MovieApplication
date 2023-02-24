//
//  Movie.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import Foundation

struct TrendingTitleResponse: Codable{
    let results : [Title]
}

struct Title: Codable{
    
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_data: String?
    let vote_average: Double?
}

/*
 {
adult = 0;
"backdrop_path" = "/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg";
"genre_ids" =             (
 12,
 878,
 35
);
id = 640146;
"media_type" = movie;
"original_language" = en;
"original_title" = "Ant-Man and the Wasp: Quantumania";
overview = "Super-Hero partners Scott Lang and Hope van Dyne, along with with Hope's parents Janet van Dyne and Hank Pym, and Scott's daughter Cassie Lang, find themselves exploring the Quantum Realm, interacting with strange new creatures and embarking on an adventure that will push them beyond the limits of what they thought possible.";
popularity = "491.948";
"poster_path" = "/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg";
"release_date" = "2023-02-10";
title = "Ant-Man and the Wasp: Quantumania";
video = 0;
"vote_average" = "7.757";
"vote_count" = 37;
},
 */
