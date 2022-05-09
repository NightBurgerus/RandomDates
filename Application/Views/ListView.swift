//
//  ListView.swift
//  Application
//
//  Created by Паша Терехов on 09.05.2022.
//

import SwiftUI

struct ListView: View {
    @StateObject var contentViewModel: ContentViewModel
    var body: some View {
        VStack {
            Text("Что было...")
                .font(.system(size: 30, weight: .bold))
            Spacer()
            List(contentViewModel.dates, id: \.id) { date in
                Text("\(date.description)")
            }
            Button("Получить сводку") {
                contentViewModel.getDates(count: 5)
            }
            .padding()
        }
    }
}
