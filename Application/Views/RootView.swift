//
//  RootView.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import SwiftUI

struct RootView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @State var mainView  = false
    @State var loginView = false
    @StateObject var rootViewModel = RootViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("", destination: ContentView(mainView: $rootViewModel.mainView), isActive: $rootViewModel.mainView)
                    .hidden()
                NavigationLink("", destination: LoginView(mainView: $rootViewModel.loginView), isActive: $rootViewModel.loginView)
                    .hidden()
            }
        }
    }
}
