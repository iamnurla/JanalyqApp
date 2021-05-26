//
//  ApiManager.swift
//  Janalyq App
//
//  Created by Nurlybek Amanzhol on 26.05.2021.
//

import Foundation

class APIManager {
   static let shared = APIManager()
    
    struct Constants {
        static let headlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=550b8ec66f9242aba9087278a0d58e0b")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=550b8ec66f9242aba9087278a0d58e0b&q="
    }
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.headlinesURL else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}


