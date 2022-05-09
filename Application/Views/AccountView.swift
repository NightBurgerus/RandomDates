//
//  AccountView.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import SwiftUI

struct AccountView: View {
    @StateObject var accountViewModel = AccountViewModel()
    @Binding var mainView: Bool
    var body: some View {
        VStack {
            Text("Личный кабинет")
                .padding()
                .font(.system(size: 25, weight: .bold))
            Spacer()
            HStack {
                Text("Имя пользователя: \(accountViewModel.username)")
                Spacer()
                Button("Изменить") {
                    accountViewModel.changeUsernameSheet.toggle()
                    accountViewModel.changeUsernameError = ""
                }
                .sheet(isPresented: $accountViewModel.changeUsernameSheet, content: {
                    Text("Новое имя пользователя")
                    TextField("username", text: $accountViewModel.newUsername)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Text(accountViewModel.changeUsernameError)
                        .foregroundColor(accountViewModel.errorColor)
                        .font(.system(size: 10))
                    
                    Button("Изменить") {
                        accountViewModel.changeUsername()
                    }
                })
            }
            HStack {
                Text("Логин: \(accountViewModel.login)")
                Spacer()
            }
            
            Spacer()
            Button("Выход") {
                self.accountViewModel.logout()
                self.mainView = false
            }
            Spacer()
        }
    }
}
