//
//  LoginRequest.swift
//  TMDb Test App
//
//  Created by Dmytro Nechuyev on 30.05.2021.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct TokenApprovementBody: Codable {
    let username: String
    let password: String
    let request_token: String
}

struct RequestToken: Codable {
    let request_token: String?
    let expires_at: String?
    let success: Bool?
}

struct TokenApprove: Codable {
    let success: Bool?
    let expires_at: Date?
    let request_token: String?
    let status_message: String?
    let status_code: String?
}

struct SessionID: Codable {
    let success: Bool?
    let session_id: String?
}

class LoginRequest {
    
    func login(username: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        
        let apiKey = "9d90da162eeebbe53910f13b0c3f369c"
        
        guard let urlRequestToken = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        guard let urlTokenApproval = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)") else {
            completion(.failure(.custom(errorMessage: "urlAccessToken error")))
            return
        }
        
        guard let urlAccessToken = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)") else {
            completion(.failure(.custom(errorMessage: "urlTokenApproval error")))
            return
        }
        
        var requestTokenURL = URLRequest(url: urlRequestToken)
        requestTokenURL.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestTokenURL) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "Request token isn't available")))
                return
            }
            
            guard let response = try? JSONDecoder().decode(RequestToken.self, from: data) else {
                completion(.failure(.custom(errorMessage: "Request decoding error")))
                return
            }
            
            guard let requestToken = response.request_token else {
                completion(.failure(.custom(errorMessage: "Request token error")))
                return
            }
            
            
            
            let approvalBody = TokenApprovementBody(username: username, password: password, request_token: requestToken)
            //let approvalBody1 = ["username": username, "password": password, "request_token": requestToken]
            
            print("body: \(approvalBody)")
            print(urlTokenApproval)
            var approvalRequest = URLRequest(url: urlTokenApproval)
            approvalRequest.httpMethod = "POST"
            approvalRequest.httpBody = try? JSONEncoder().encode(approvalBody)

            URLSession.shared.dataTask(with: approvalRequest) { (data, response, error) in

                guard let data = data, error == nil else {
                    completion(.failure(.custom(errorMessage: "No approval data")))
                    return
                }
                print("Data: \(data)")
                print(response)
                print(error)
                //try! JSONDecoder().decode(TokenApprove.self, from: data)
                
                guard let approvalResponse = try? JSONDecoder().decode(TokenApprove.self, from: data) else {
                    print("Approve decode error")
                    completion(.failure(.invalidCredentials ))
                    return
                }
            
                print("Approval resp: \(approvalResponse)")
                
                guard let successApproval = approvalResponse.success else {
                    completion(.failure(.custom(errorMessage: "Approval success check error")))
                    return
                }

                print("Approval: \(successApproval)")
                
                if successApproval == true {
                    
                    var accessTokenURL = URLRequest(url: urlAccessToken)
                    accessTokenURL.httpMethod = "POST"
                    
                    URLSession.shared.dataTask(with: accessTokenURL) { (data, response, error) in
                        
                        guard let data = data, error == nil else {
                            completion(.failure(.custom(errorMessage: "Request access token isn't available")))
                            return
                        }
                        
                        guard let accessTokenResponse = try? JSONDecoder().decode(SessionID.self, from: data) else {
                            completion(.failure(.custom(errorMessage: "Access decoding error")))
                            return
                        }
                        
                        guard let sessionId = accessTokenResponse.session_id else {
                            completion(.failure(.custom(errorMessage: "Access token error")))
                            return
                        }
                        
                        completion(.success(sessionId))
                        print(sessionId)
                        
                    }.resume()
                }
                
            }.resume()
            
        }.resume()
        
    }
    
}
