//
//  User.swift
//  Application
//
//  Created by Паша Терехов on 08.05.2022.
//

import Foundation
import CoreData

class Users {
    static let managedContext = DataController().container.viewContext
    static var users: [NSManagedObject] = []
    static var lastLogins: [NSManagedObject] = []
    
    static func getUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func getLastLogins() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "LastLogin")
        
        do {
            lastLogins = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static private func authUser() -> NSManagedObject? {
        getLastLogins()
        for user in lastLogins {
            if user.value(forKey: "isLogin") as! Bool {
                return user
            }
        }
        return nil
    }
    
    static func getAuthUser() -> NSManagedObject? {
        if let user = authUser() {
            getUsers()
            for i in users {
                if i.value(forKey: "login") as! String == user.value(forKey: "login") as! String {
                    return i
                }
            }
        }
        return nil
    }
    
    static func hasLogin(login: String) -> Bool {
        getUsers()
        for user in self.users {
            if login == user.value(forKey: "login") as! String {
                
                return true
            }
        }
        return false
    }
    
    static func changeUsername(_ username: String, new newUsername: String) -> Bool {
        getUsers()
        for user in users {
            if user.value(forKey: "username") as! String == username {
                user.setValue(newUsername, forKey: "username")
                try? managedContext.save()
                return true
            }
        }
        return false
    }
}
