//
//  ApplicationApp.swift
//  Application
//
//  Created by Паша Терехов on 06.05.2022.
//

import SwiftUI

@main
struct ApplicationApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
