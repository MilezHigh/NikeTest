//
//  TopAlbumDetailViewModel.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/8/21.
//

import Foundation

class TopAlbumDetailViewModel {
    var album: AlbumObjectModel
    var headerImageData: Data?
    
    private let api: UtilityAPI = API.instance

    init(album: AlbumObjectModel, headerImageData: Data?) {
        self.album = album
        self.headerImageData = headerImageData
    }
}

extension TopAlbumDetailViewModel {
    
    func fetchCachedImage(for urlString: String, _ completion: @escaping (Result<Data?, APIError>) -> Void) {
        API.instance.fetchImageData(from: urlString) { (result) in
            completion(result)
        }
    }
}
