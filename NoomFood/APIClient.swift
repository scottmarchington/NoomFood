//
//  APIClient.swift
//  NoomFood
//
//  Created by Scott Marchington on 10/1/21.
//

import Foundation

class APIClient {
    enum Error: Swift.Error {
        case invalidURL
        case missingData
        case responseError(Swift.Error)
        case decodingError(Swift.Error)
    }
    
    var currentTask: URLSessionDataTask?
    
    func searchFood(text: String, completion: @escaping (Result<[Food], Error>) -> Void) {
        let escapedText = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let urlString: String = "https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search?kv=\(escapedText)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        currentTask?.cancel()
        
        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.responseError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.missingData))
                return
            }
            
            let foods: [Food]
            do {
                foods = try JSONDecoder().decode([Food].self, from: data)
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
            completion(.success(foods))
        }
        
        currentTask?.resume()
    }
}
