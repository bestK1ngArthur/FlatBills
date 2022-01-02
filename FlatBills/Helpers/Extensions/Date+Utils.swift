//
//  Date+Utils.swift
//  Flame
//
//  Created by Artem Belkov on 01.11.2021.
//

import Foundation

extension Date {
    /// Date of Now
    /// Returns start of the current date
    /// Example: 01.01.2021 11:22
    static var now: Date { Date() }
    
    /// Date of Today
    /// Returns start of the current date
    /// Example: 01.01.2021 00:00
    static var today: Date { now.midnight }

    /// Date of Tomorrow
    /// Returns start of the next date
    /// Example: 02.01.2021 00:00
    static var tomorrow: Date? { now.midnight.adding(days: 1) }
    
    /// Date of Today Midnight
    /// Returns start date of the current day
    /// Example: 01.01.2021 00:00
    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Date of Today Midday
    /// Returns middle date of the current day
    /// Example: 01.01.2021 12:00
    var midday: Date {
        guard let date = midnight.adding(hours: 12) else {
            fatalError("Midday date can't be nil")
        }

        return date
    }
    
    // MARK: Components
    
    /// Day of month
    var day: Int { getComponent(.day) }
    
    /// Month of year
    var month: Int { getComponent(.month) }
    
    /// Year
    var year: Int { getComponent(.year) }
    
    // MARK: Adding
    
    /// Returns date with adding components
    /// Example: 01.01.2021 01:00 (+1 hour)
    func adding(seconds: Int = 0,
                minutes: Int = 0,
                hours: Int = 0,
                days: Int = 0,
                months: Int = 0,
                years: Int = 0) -> Date? {
        var dateComponents = DateComponents()
        
        dateComponents.second = seconds
        dateComponents.minute = minutes
        dateComponents.hour = hours
        dateComponents.day = days
        dateComponents.month = months
        dateComponents.year = years
                        
        return Calendar.current.date(byAdding: dateComponents, to: self)
    }
    
    // MARK: Private
    
    private func getComponent(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}
