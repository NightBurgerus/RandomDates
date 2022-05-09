//
//  RootViewModel.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import CoreData
import Combine

class RootViewModel: ObservableObject {
    @Published var mainView  = false
    @Published var loginView = false
    
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        if getAuthUser() != nil {
            mainView = true
        } else {
            loginView = true
        }
        
        $mainView
            .sink(receiveValue: {value in
                if !value {
                    self.loginView = true
                }
            })
            .store(in: &cancellableSet)
        $loginView
            .sink(receiveValue: {value in
                if !value {
                    self.mainView = true
                }
            })
            .store(in: &cancellableSet)
    }
    
    func changeView() {
        mainView.toggle()
        loginView.toggle()
    }
    
    func getAuthUser() -> NSManagedObject? {
        let managedObjectContext = DataController().container.viewContext
        var users: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            users = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
        for user in users {
            if user.value(forKey: "isLogin") as? Bool ?? false {
                return user
            }
        }
        
        return nil
    }
}
