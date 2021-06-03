//
//  PopularFilmsView.swift
//  TMDb Test App
//
//  Created by Dmytro Nechuyev on 03.06.2021.
//

import SwiftUI

struct PopularFilmsView: View {
    
    @ObservedObject var popularFilmsModel = PopularFilmModel()
    let imageUrl = "https://image.tmdb.org/t/p/w185"
    let layout = [
        GridItem(.flexible(), spacing: -25),
        GridItem(.flexible(), spacing: -25)
    ]
    
    var body: some View {

        Divider()
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(popularFilmsModel.popularFilms, id:\.self) { film in
                    ZStack{
                        
                    let url = imageUrl + film.poster_path!
                    ItemImage(url: url)
                        .overlay(
                        Text(film.title ?? "No title")
                            .font(.title2)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(
                                RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 15)
                                    .fill(Color("BlackOpacity")))
                            .foregroundColor(.white)
                            , alignment: .bottom
                        )
                    }
                }
            }

        }.onAppear(perform: {
            popularFilmsModel.request()
        })
            .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Popular Movies", displayMode: .large)
    }
}

struct PopularFilmsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularFilmsView()
            .previewDevice("iPhone 11")
    }
}

struct ItemImage: View {
    @ObservedObject private var imageLoader = ImageLoader()
    
    init(url: String){
        self.imageLoader.load(url: url)
    }
    
    var body: some View {
        if let image = self.imageLoader.downloadedImage {
            Image(uiImage: image)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            Image(systemName: "photo")
        }
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
