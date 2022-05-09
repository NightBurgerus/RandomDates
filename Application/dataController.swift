//
//  dataController.swift
//  Application
//
//  Created by Паша Терехов on 06.05.2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    var container = NSPersistentContainer(name: "UserInfo")
    
    init() {
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Error while loading persistent stores: \(error.localizedDescription)")
            }
        })
    }
}
