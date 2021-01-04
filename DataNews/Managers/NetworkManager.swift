//
//  NetworkManager.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class NetworkManager {
    
    //MARK: - Constants
    
    static let shared = NetworkManager()
    private let baseUrl = "http://api.datanews.io/v1/news?"
    private let apiKey = "08gtieyw6datcwhhfclhi3zc1"
    private(set) var pageSize = 30
    private let cache = NSCache<NSString, UIImage>()
    
    //MARK: - Properties
    
    //MARK: - Public methods
    
    func getNews(page: Int,
             language: String,
              country: String,
            completed: @escaping (Result<NewsData, DNError>) -> Void) {
        
        let endpoint = baseUrl + "apiKey=\(apiKey)&page=\(page)&size=\(pageSize)&language=\(language)&country=\(country)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.somethingWentWrong))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let responseData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newsData = try decoder.decode(NewsData.self, from: responseData)
                completed(.success(newsData))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    
    //MARK: - Private methods
    
    private init() {}
}
