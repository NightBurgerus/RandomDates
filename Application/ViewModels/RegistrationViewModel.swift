//
//  RegistrationViewModel.swift
//  Application
//
//  Created by Паша Терехов on 08.05.2022.
//

import SwiftUI
import Combine
import CoreData

class RegistrationViewModel: ObservableObject {
    let managedContext = DataController().container.viewContext
    var users: [NSManagedObject] = []
    
    // input
    @Published var username   = ""
    @Published var login      = ""
    @Published var password   = ""
    @Published var repeatPass = ""
    
    // output
    @Published var usernameError   = ""
    @Published var loginError      = ""
    @Published var passwordError   = ""
    @Published var repeatPassError = ""
    @Published var isButtonEnabled = false
    @Published var buttonColor     = Color.blue
    
    var cancellableSet: Set<AnyCancellable> = []
    
    // Проверка имени пользователя.
    private var isUsernameValid: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ username in
                var hasUsername = false
                for user in self.users {
                    if username == user.value(forKey: "username") as! String {
                        hasUsername = true
                        break
                    }
                }
                
                if username.count > 3 && !hasUsername{
                    self.usernameError = ""
                    return true
                }
                if hasUsername {
                    self.usernameError = "Данное имя пользователя уже занято"
                    return false
                }
                if username.count > 0 {
                    self.usernameError = "Имя пользователя должно быть более 3 символов"
                } else {
                    self.usernameError = ""
                }
                return false
            })
            .eraseToAnyPublisher()
    }
    
    
    // Проверка логина.
    private var isLoginValid: AnyPublisher<Bool, Never> {
        $login
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ login in
                var hasLogin = false
                for user in self.users {
                    if login == user.value(forKey: "login") as! String {
                        hasLogin = true
                        break
                    }
                }
                
                if login.count > 3 && !hasLogin {
                    self.loginError = ""
                    return true
                }
                if hasLogin {
                    self.loginError = "Данный логин уже занят"
                    return false
                }
                if login.count > 0 {
                    self.loginError = "Логин должен быть более 3 символов"
                } else {
                    self.loginError = ""
                }
                return false
            })
            .eraseToAnyPublisher()
    }
    
    /// Проверка пароля на длину
    private var isPasswordLong: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ password in
                if password.count > 3 {
                    self.passwordError = ""
                    return true
                }
                if password.count > 0 {
                    self.passwordError = "Пароль должен содержать более 3 символов"
                } else {
                    self.passwordError = ""
                }
                return false
            })
            .eraseToAnyPublisher()
    }
    
    /// Проверка подтверждения пироля
    private var isPasswordsEqual: AnyPublisher<Bool, Never> {
        $repeatPass
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map({_ in
                if self.password == self.repeatPass && self.repeatPass.count > 0 {
                    self.repeatPassError = ""
                    return true
                }
                if self.repeatPass.count > 0 {
                    self.repeatPassError = "Пароли не совпадают"
                } else {
                    self.repeatPassError = ""
                }
                return false
            })
            .eraseToAnyPublisher()
    }
    
    private var isPasswordsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordLong, isPasswordsEqual)
            .map({ passwordLong, passwordsEqual in
                if passwordLong && passwordsEqual {
                    return true
                }
                return false
            })
            .eraseToAnyPublisher()
    }
    
    init() {
        getUsers()
        Publishers.CombineLatest3(isUsernameValid, isLoginValid, isPasswordsValid)
            .map({ usernameIsValid, loginIsValid, passwordIsValid in
                if usernameIsValid && loginIsValid && passwordIsValid {
                    self.buttonColor = Color.blue
                    return true
                }
                self.buttonColor = Color.gray
                return false
            })
            .assign(to: \.isButtonEnabled, on: self)
            .store(in: &cancellableSet)
    }
    
    func getUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func registerUser() {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let user = NSManagedObject.init(entity: entity!, insertInto: managedContext)
        
        user.setValue(username, forKey: "username")
        user.setValue(login, forKey: "login")
        user.setValue(password, forKey: "password")
        user.setValue(false, forKey: "isLogin")
        
        try? managedContext.save()
        getUsers()
        
        print("Registration")
        for user in users {
            print("\(user.value(forKey: "login") as! String): \(user.value(forKey: "isLogin") as? Bool ?? false)")
        }
        
    }
    
}

