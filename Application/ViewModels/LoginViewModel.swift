//
//  LoginViewModel.swift
//  Application
//
//  Created by Паша Терехов on 08.05.2022.
//

import Combine
import CoreData

class LoginViewModel: ObservableObject {
    let managedObjectContext = DataController().container.viewContext
    var users: [NSManagedObject] = []
    
    @Published var login     = ""
    @Published var password  = ""
    
    @Published var toRegister    = false
    @Published var loginMessage  = ""
    
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest($login, $password)
            .sink(receiveValue: {login, password in
                self.loginMessage = ""
            })
            .store(in: &cancellableSet)
    }
    
    func loginTapped() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        do {
            users = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
        for user in users {
            if user.value(forKey: "login") as! String == login {
                if user.value(forKey: "password") as! String == password {
                    loginMessage = ""
                    user.setValue(true, forKey: "isLogin")
                    try? managedObjectContext.save()
                    return true
                }
            }
        }
        
        loginMessage = "Неверный логин или пароль"
        return false
    }
}
