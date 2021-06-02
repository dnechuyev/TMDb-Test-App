//
//  ContentView.swift
//  TMDb Test App
//
//  Created by developer on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()
       
       var body: some View {
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
                       }
                       Spacer()
                   }
               }.buttonStyle(PlainButtonStyle())
               
              
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
