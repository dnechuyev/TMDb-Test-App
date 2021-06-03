//
//  ContentView.swift
//  TMDb Test App
//
//  Created by Dmytro Nechuyev on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    HStack {
                        Spacer()
                        Image(systemName: loginVM.isAuthenticated ? "lock.open": "lock.fill")
                    }
                    TextField("Username", text: $loginVM.username)
                    SecureField("Password", text: $loginVM.password)
                    HStack {
                        Spacer()
                        Button("Login") {
                            loginVM.login()
                            loginVM.isAuthenticated = true // LoginRequest doesn't wort. Tmp desigion
                        }
                        
                        Spacer()
                    }
                }.buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: PopularFilmsView(),
                    isActive: $loginVM.isAuthenticated)
                    {
                        EmptyView()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11")
        }
    }
}
