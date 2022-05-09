//
//  ContentViewModel.swift
//  Application
//
//  Created by Паша Терехов on 08.05.2022.
//

import SwiftUI
import Combine
import Alamofire
import CoreData

struct UserDate {
    var id: String
    var day: Int
    var description: String
}

class ContentViewModel: ObservableObject {
    let managedObjectContext           = DataController().container.viewContext
    @Published var dates: [UserDate]   = []
    @Published var selectedDate        = Date()
    @Published var alert               = false
    
    func addDate(date: Date) {
        let localDate = date.description.prefix(10).split(separator: "-")
        Alamofire.request("http://numbersapi.com/\(localDate[1])/\(localDate[2])/date?json", encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            if let result = response.result.value {
                let json = result as! Dictionary<String, Any>
                let date = UserDate(id: UUID().uuidString, day: json["number"] as! Int, description: json["text"] as! String)
                self.dates.append(date)
                self.dates = self.dates.sorted(by: {date1, date2 in return date1.day < date2.day})
            }
        })
    }
    
    func getDates(count: Int) {
        dates = []
        for _ in 0..<count {
            
            var randomDay = String((1...31).randomElement()!)
            if Int(randomDay)! < 10 {
                randomDay = "0" + randomDay
            }
            var randomMonth = String((1...12).randomElement()!)
            if Int(randomMonth)! < 10 {
                randomMonth = "0" + randomMonth
            }
            
            Alamofire.request("http://numbersapi.com/\(randomMonth)/\(randomDay)/date?json", encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
                if let result = response.result.value {
                    let json = result as! Dictionary<String, Any>
                    let date = UserDate(id: UUID().uuidString, day: json["number"] as! Int, description: json["text"] as! String)
                    self.dates.append(date)
                    self.dates = self.dates.sorted(by: {date1, date2 in return date1.day < date2.day})
                }
            })
        }
    }
}
