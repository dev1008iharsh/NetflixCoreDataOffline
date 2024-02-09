//
//  Movies.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import Foundation

struct TitleShowResponcse : Codable{
    let results : [MovieModel]
}

struct MovieModel : Codable,Equatable {
    var id : Int
    let media_type : String?
    var original_name : String?
    var original_title : String?
    let poster_path : String?
    var overview : String?
    let release_date : String?
    let vote_average : Double
    
    static func ==(lhs: MovieModel, rhs: MovieModel) -> Bool {
        return lhs.poster_path == rhs.poster_path || lhs.id == rhs.id
        // Add comparisons for additional properties if needed
    }
}
/*
struct OfflineMovie : Codable {
    var id : Int
    let media_type : String?
    var original_name : String?
    var original_title : String?
    let poster_path : String?
    var overview : String?
    let release_date : String?
    let vote_average : Double
}*/
/*
struct Results: Codable {

    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: String
    let mediaType: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

}*/
 
