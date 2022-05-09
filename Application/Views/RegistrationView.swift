//
//  ContentView.swift
//  Application
//
//  Created by Паша Терехов on 06.05.2022.
//
import SwiftUI

struct RegistrationView: View {
    @StateObject var registrationViewModel = RegistrationViewModel()
    @Binding var loginView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Section(footer: Text(registrationViewModel.usernameError)
                            .foregroundColor(.red)
                            .font(.system(size: 10))) {
                    HStack {
                        Text("Имя пользователя")
                            .font(.system(size: 16))
                            .foregroundColor(Color.init(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)))
                        Spacer()
                    }
                    TextField("Username", text: $registrationViewModel.username)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .padding(.bottom, 5)
                
                Section(footer: Text(registrationViewModel.loginError)
                            .foregroundColor(.red)
                            .font(.system(size: 10))) {
                    HStack {
                        Text("Логин")
                            .font(.system(size: 16))
                            .foregroundColor(Color.init(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)))
                        Spacer()
                    }
                    TextField("Login", text: $registrationViewModel.login)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .padding(.bottom, 3)
                
                Section(footer: Text(registrationViewModel.passwordError)
                            .foregroundColor(.red)
                            .font(.system(size: 10))) {
                    HStack {
                        Text("Пароль")
                            .font(.system(size: 16))
                            .foregroundColor(Color.init(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)))
                        Spacer()
                    }
                    SecureField("Password", text: $registrationViewModel.password)
                }
                Spacer()
                
                Section(footer: Text(registrationViewModel.repeatPassError)
                            .foregroundColor(.red)
                            .font(.system(size: 10))) {
                    HStack {
                        Text("Подтверждение пароля")
                            .font(.system(size: 16))
                            .foregroundColor(Color.init(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)))
                        Spacer()
                    }
                    SecureField("Password again", text: $registrationViewModel.repeatPass)
                }
                Spacer()
                
                Button("Зарегистрироваться") {
                    registrationViewModel.registerUser()
                    
                    // Выход в окно авторизации
                    self.loginView = false
                }
                .disabled(!registrationViewModel.isButtonEnabled)
                .padding(10)
                .background(registrationViewModel.buttonColor)
                .cornerRadius(10.0)
                .foregroundColor(.white)
            }
        }
        .navigationTitle(Text("Регистрация"))
    }
}
