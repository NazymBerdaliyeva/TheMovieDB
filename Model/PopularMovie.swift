//
//  PopularMovie.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

struct PopularMovie: Decodable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]?
}

struct Result:Decodable {
    let title: String?
    let poster_path: String?
    let genre_ids: [Int]?
}
