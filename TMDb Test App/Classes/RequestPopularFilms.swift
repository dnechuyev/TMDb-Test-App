//
//  RequestPopularFilms.swift
//  TMDb Test App
//
//  Created by Dmytro Nechuyev on 02.06.2021.
//

import Foundation

struct PopularFilms: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [Films]?
}

struct Films: Codable, Hashable {
    let poster_path: String?
    let id: Int?
    let title: String?
}

class RequestPopularFilms {
    
    func request(page: Int = 1, completion: @escaping(Result<PopularFilms, AuthenticationError>) -> Void) {
    
        let apiKey = "9d90da162eeebbe53910f13b0c3f369c"
        
        guard let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }

        var requestFilms = URLRequest(url: urlRequest)
        requestFilms.httpMethod = "GET"
        print(requestFilms)
        
        URLSession.shared.dataTask(with: requestFilms) { (data, response, error) in

            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "Request token isn't available")))
                return
            }
            guard let response = try? JSONDecoder().decode(PopularFilms.self, from: data) else {
                print("popular error")
                completion(.failure(.custom(errorMessage: "Request decoding error")))
                return
            }
            
            completion(.success(response))
        }.resume()
        
    }
    
}
