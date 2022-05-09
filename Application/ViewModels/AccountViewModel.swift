//
//  AccountViewModel.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import SwiftUI
import Combine
import Alamofire
import CoreData

class AccountViewModel: ObservableObject {
    let managedObjectContext = DataController().container.viewContext
    
    @Published var changeUsernameSheet = false
    @Published var newUsername         = ""
    @Published var changeUsernameError = ""
    @Published var errorColor          = Color.red
    @Published var username            = ""
    @Published var login               = ""
    
    init() {
        if let user = self.getAuthUser() {
            username = user.value(forKey: "username") as! String
            login    = user.value(forKey: "login") as! String
        }
    }
    
    func changeUsername() {
        let managedObjectContext = DataController().container.viewContext
        var users: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            users = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
        for user in users {
            if user.value(forKey: "username") as! String == newUsername {
                changeUsernameError = "Данное имя пользователя уже занято"
                return
            }
            if newUsername.count < 3 {
                changeUsernameError = "Имя пользователя должно содержать более 3 символов"
                errorColor          = Color.red
                return
            }
        }
        
        for user in users {
            if user.value(forKey: "username") as! String == username {
                user.setValue(newUsername, forKey: "username")
                break
            }
        }
        changeUsernameError = "Имя пользователя успешно изменено"
        errorColor          = Color.green
        username            = newUsername
        newUsername         = ""
        try? managedObjectContext.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.changeUsernameSheet = false
        }
    }
    
    func getAuthUser() -> NSManagedObject? {
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
    
    func logout() {
        if let user = self.getAuthUser() {
            user.setValue(false, forKey: "isLogin")
            try? managedObjectContext.save()
        } else {
            print("Авторизованных пользователей нет")
        }
    }
}
