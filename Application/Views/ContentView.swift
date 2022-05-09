//
//  ContentView.swift
//  Navigation
//
//  Created by Паша Терехов on 07.05.2022.
//

import SwiftUI

struct ContentView: View {
    @Binding var mainView: Bool
    @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                ListView(contentViewModel: contentViewModel)
                .tabItem( {
                    Image(systemName: "house.fill")
                    Text("Главная")
                })
                
                AddView(contentViewModel: contentViewModel)
                .tabItem( {
                    Image(systemName: "plus")
                    Text("Добавление")
                })
                
                AccountView(mainView: $mainView)
                .tabItem( {
                    Image(systemName: "person.fill")
                    Text("Личный кабинет")
                })
            }

        }
        .navigationBarHidden(true)
    }
}
