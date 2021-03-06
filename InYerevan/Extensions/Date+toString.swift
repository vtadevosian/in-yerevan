//
//  Date+toString¸.swift
//  InYerevan
//
//  Created by Davit Ghushchyan on 1/13/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation

extension Date {

    // NARK:  BEGINING AND END OF DAY
    var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1 
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    // NARK:  BEGINING AND END OF WEEK
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) 
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 7, to: sunday!)!
    }

    // NARK:  BEGINING AND END OF MONTH
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var duringOneYear: Date {
        return self + (60 * 60 * 24 * 30 * 12)
    }
    
    static func weeakdayByString(numberDay: Int) -> String {
        switch numberDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sut"
        default:
            return ""
        }
    }
}
