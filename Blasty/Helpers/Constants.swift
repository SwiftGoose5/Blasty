//
//
//
// Created by Swift Goose on 4/11/22 AT 10:17 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Map Tiling
let columns = 64
let rows = 64



// MARK: - Collectibles
let totalCollectibles = 6
let collectibleSet = CollectibleSet()
var collectibleCount = 0



// MARK: - Player
let totalLives = 6
var lifeCount = 0



// MARK: - Collision Types

enum CollisionType: UInt32 {
    case player = 1
    case ground = 2
    case spikes = 4
    case victory = 8
    case field = 16
    case collectible = 32
}

let progressUpdate = Notification.Name("com.progress")
let tenPercent = Notification.Name("10")
let twentyPercent = Notification.Name("20")
let thirtyPercent = Notification.Name("30")
let fourtyPercent = Notification.Name("40")
let fiftyPercent = Notification.Name("50")
let sixtyPercent = Notification.Name("60")
let seventyPercent = Notification.Name("70")
let eightyPercent = Notification.Name("80")
let ninetyPercent = Notification.Name("90")
let hundredPercent = Notification.Name("100")

