//
//
//
// Created by Swift Goose on 4/27/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

extension Date {

    var numberOfSecondsUntilMidnight: TimeInterval? {
        let todayDate = self
        let tomorrowDate = todayDate.tomorrowAtMidnight
        return tomorrowDate.timeIntervalSince(self)

    }

    var tomorrowAtMidnight: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        let today =  cal.startOfDay(for: self)
        
        return Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }
    
    var launchDateIsInToday: Bool {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current

        return cal.isDate(self, inSameDayAs: launchDate)
//        return cal.isDateInYesterday(self)
    }
}
