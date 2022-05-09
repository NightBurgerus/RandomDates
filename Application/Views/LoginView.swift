//
//  LoginView.swift
//  Application
//
//  Created by Паша Терехов on 07.05.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State var loginView = false
    @Binding var mainView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Авторизация")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                Section {
                    HStack {
                        Text("Логин")
                        Spacer()
                    }
                    TextField("Логин", text: $loginViewModel.login)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.bottom)
                Section {
                    HStack {
                        Text("Пароль")
                        Spacer()
                    }
                    SecureField("Пароль", text: $loginViewModel.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.bottom)
                Text(loginViewModel.loginMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                Spacer()
                Button("Войти") {
                    if loginViewModel.loginTapped() {
                        self.mainView = false
                    }
                }
                
                Button("Зарегистрироваться") {
                    loginView.toggle()
                }
                .padding(.bottom)
                NavigationLink("Зарегистрироваться 2", destination: RegistrationView(loginView: $loginView), isActive: $loginView)
                    .hidden()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
