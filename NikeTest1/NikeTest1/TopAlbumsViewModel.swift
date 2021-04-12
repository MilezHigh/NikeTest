//
//  RSSViewModel.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/6/21.
//

import Foundation

class TopAlbumsViewModel {
    
    private var rssFeedLimit: Int = 0
    
    init(rssFeedLimit: Int) {
        self.rssFeedLimit = rssFeedLimit
    }
    
    func fetchRSSFeed(_ completion: @escaping (Result<[RSSFeedObjectModel], APIError>) -> Void) {
        API.instance.fetchRSSFeed(limit: rssFeedLimit) { (result) in
            completion(result)
        }
    }
}
