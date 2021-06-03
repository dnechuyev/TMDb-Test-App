//
//  PopularFilmModel.swift
//  TMDb Test App
//
//  Created by Dmytro Nechuyev on 02.06.2021.
//

import Foundation

class PopularFilmModel: ObservableObject {
    
    var page: Int = 1
    @Published var popularFilms = [Films]()
    
    func request() {
        
        RequestPopularFilms().request(page: page) { result in
            switch result {
            case .success(let popularFilmsRes):
                DispatchQueue.main.async {
                    self.popularFilms = popularFilmsRes.results ?? [Films]()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
