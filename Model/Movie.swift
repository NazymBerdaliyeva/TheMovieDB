//
//  Movie.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int?
    let title: String?
    let poster_path: String?
}

struct MovieDetails: Decodable{
    let id: Int?
    let title: String?
    let overview: String?
    let poster_path: String?
    let genres: [Genre]?
    let release_date: String?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? -1
        name = json["name"] as? String ?? ""
        
    }
}
