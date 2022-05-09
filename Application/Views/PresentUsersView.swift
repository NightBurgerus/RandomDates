//
//  PresetUsersView.swift
//  Application
//
//  Created by Паша Терехов on 07.05.2022.
//

import SwiftUI
import CoreData

class PresentUsersViewModel: ObservableObject {
    let managedObjectContext = DataController().container.viewContext
    var users: [NSManagedObject] = []

    func getUsers() -> [NSManagedObject] {
        var users: [NSManagedObject] = []
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        do {
            users = try managedObjectContext.fetch(fetch) as? [NSManagedObject] ?? []
        } catch {
            print(error.localizedDescription)
        }
        
        return users
    }
}

struct PresentUsersView: View {
    @StateObject var presentUsersViewModel = PresentUsersViewModel()
    @State var usersView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                VStack {
                    List (presentUsersViewModel.getUsers(), id: \.self) { user in
                        Text("\(user.value(forKey: "login") as! String): \(user.value(forKey: "username") as! String)")
                            .foregroundColor(.black)
                    }
                    NavigationLink(destination: LoginView(mainView: $usersView), isActive: $usersView) {
                        Text("fuck")
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}















struct PresentUsersView_Previews: PreviewProvider {
    static var previews: some View {
        PresentUsersView()
    }
}
