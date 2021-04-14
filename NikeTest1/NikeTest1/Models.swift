//
//  Models.swift
//  NikeTest1
//
//  Created by Miles Fishman on 4/14/21.
//

import Foundation

struct MusicGenre: Decodable {
    var genreId: String
    var name: String
}

struct AlbumObjectModel: Decodable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var copyright: String
    var artworkUrl100: String
    var genres: [MusicGenre]
    var url: String
}

struct RSSChildResponseModel: Decodable {
    var title: String
    var id: String
    var results: [AlbumObjectModel]
}

struct RSSParentResponseModel: Decodable {
    var feed: RSSChildResponseModel
}
