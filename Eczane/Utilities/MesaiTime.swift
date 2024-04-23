//
//  CurrentDateTime.swift
//  Eczane
//
//  Created by Emir Öztürk on 20.03.2024.
//

import Foundation

public class MesaiTime {
    public func isNormalTime() -> Bool {
        let timeZone = TimeZone(identifier: "Europe/Istanbul")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var currentDate = Date()
        dateFormatter.timeZone = timeZone

        if let modifiedDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) {
            currentDate = modifiedDate
        }

        var turkeyTime = dateFormatter.string(from: currentDate)
        
        turkeyTime = turkeyTime.replacingOccurrences(of: ":", with: "")
        
        guard let hour = Int(turkeyTime.prefix(2)) else { return false }
        
        let gun = getDate()
        if gun == "Normal" {
            if hour >= 9 && hour < 19  {
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
    
    private func getDate() -> String {
        let gunSirasi = Calendar.current.component(.weekday, from: Date()) - 1
        
        switch gunSirasi {
        case 1,2,3,4,5,6:
            return "Normal"
        default:
            return "Pazar"
        }
    }
}
