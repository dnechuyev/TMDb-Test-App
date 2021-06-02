//
//  Login Model.swift
//  TMDb Test App
//
//  Created by developer on 31.05.2021.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    var username: String = ""
    var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        
        let defaults = UserDefaults.standard
        
        LoginRequest().login(username: username, password: password) { result in
            switch result {
                case .success(let sessionId):
                    defaults.setValue(sessionId, forKey: "sessionId")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
}
