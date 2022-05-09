//
//  AddView.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import SwiftUI

struct AddView: View {
    @StateObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack{
            Text("Добавление даты")
                .padding()
                .font(.system(size: 30))
            Spacer()
            DatePicker("Дата", selection: $contentViewModel.selectedDate, displayedComponents: .date)
            Spacer()
            Button("Добавить дату") {
                contentViewModel.addDate(date: contentViewModel.selectedDate)
                contentViewModel.alert.toggle()
            }
            .alert(isPresented: $contentViewModel.alert, content: {
                    Alert(title: Text("Дата добавлена"), message: Text("Для просмотра информации перейдите на главную страницу"), dismissButton: .none)
            })
            Spacer()
        }
    }
}
