//
//  NetworkClient.swift
//  CompleteTheMovieTitle
//
//  Created by Osama Gamal on 25/05/2021.
//

import Foundation
/// Example Usage:

class MyRequest: RequestProtocol {
    
    var url: URL {
        return URL(string: urlStr)!
    }
    
    var urlStr: String = ""
  
    init(urlStr: String) {
        self.urlStr = urlStr
    }
}

protocol RequestProtocol {
    var url: URL { get }
}

class NetworkClient {
    class func get(request: RequestProtocol, completion: @escaping (Result<Data, Error>) -> ()){
        let urlRequest = URLRequest(url: request.url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkError.networkError))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case noData
    case networkError
}
