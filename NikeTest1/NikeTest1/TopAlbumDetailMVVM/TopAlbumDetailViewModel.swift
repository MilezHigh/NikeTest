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
    
    let api = API.instance
    
    init(album: AlbumObjectModel, headerImageData: Data?) {
        self.album = album
        self.headerImageData = headerImageData
    }
}

extension TopAlbumDetailViewModel {
    
    func fetchCachedImage() {
        API.instance.fetchImageData(from: "") { (result) in
            <#code#>
        }
    }
}
