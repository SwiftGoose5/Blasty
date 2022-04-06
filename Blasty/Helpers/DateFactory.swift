//
//
//
// Created by Swift Goose on 4/6/22 AT 10:20 AM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

struct DateFactory {
    static var dateSeed : Int32 {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        return Int32(dateFormatter.string(from: date))!
    }
}
