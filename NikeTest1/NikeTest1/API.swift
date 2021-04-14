//
//  API.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/6/21.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(message: String)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .networkError(let message):
            return message
        }
    }
}

// MARK: - API Protocols
protocol AppleRSSFeedAPI {
    func appleTopAlbumsFeed(limit: Int, _ completion: @escaping (Result<[AlbumObjectModel], APIError>) -> Void)
}

protocol UtilityAPI {
    func fetchImageData(from urlString: String, _ completion: @escaping (Result<Data?, APIError>) -> Void)
}

class API {
    let cache = NSCache<NSString, NSData>()
    
    static let instance: API = API()
    
    private func request<T: Decodable>(
        responseType: T.Type,
        urlString: String,
        _ completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let err = error else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 || response.statusCode == 201 else {
                    completion(.failure(.networkError(message: "Response is invalid")))
                    return
                }
                guard let data = data else {
                    completion(.failure(.networkError(message: "Data is missing")))
                    return
                }
                do {
                    let object = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.networkError(message: error.localizedDescription)))
                }
                return
            }
            completion(.failure(.networkError(message: err.localizedDescription)))
        }
        .resume()
    }
}

// MARK: - AppleRSSFeed
extension API: AppleRSSFeedAPI {
    func appleTopAlbumsFeed(limit: Int = 100, _ completion: @escaping (Result<[AlbumObjectModel], APIError>) -> Void) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/\(limit)/explicit.json"
        request(responseType: RSSParentResponseModel.self, urlString: urlString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.feed.results))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Utility
extension API: UtilityAPI {
    func fetchImageData(from urlString: String, _ completion: @escaping (Result<Data?, APIError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            var result: Data?
            var err: APIError?
            
            if let url = URL(string: urlString) {
                let urlNSString = NSString(string: urlString)
                do {
                    if let cachedData = self.cache.object(forKey: urlNSString) {
                        result = cachedData as Data
                    } else {
                        let data = try Data(contentsOf: url)
                        self.cache.setObject(NSData(data: data), forKey: urlNSString)
                        result = data
                    }
                } catch {
                    err = .networkError(message: error.localizedDescription)
                }
            } else {
                err = .invalidURL
            }
            
            DispatchQueue.main.async {
                guard let err = err else {
                    completion(.success(result))
                    return
                }
                completion(.failure(err))
            }
        }
    }
}
