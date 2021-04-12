//
//  TopAlbumDetailViewModel.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/8/21.
//

import Foundation

class TopAlbumDetailViewModel {
    
     var album: RSSFeedObjectModel
    
    var headerImageData: Data?

    init(album: RSSFeedObjectModel, headerImageData: Data?) {
        self.album = album
        self.headerImageData = headerImageData
    }
}
