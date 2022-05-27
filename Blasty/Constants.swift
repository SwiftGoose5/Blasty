//
//
//
// Created by Swift Goose on 4/11/22 AT 10:17 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//
import Foundation
import SpriteKit

// MARK: - Daily Completion
var isDayComplete = false
var wasVictory = false

var launchDate = Date()

var timeUntilMidnight = TimeInterval(0)
var secondsUntilMidnight = 0
var minutesUntilMidnight = 0
var hoursUntilMidnight = 0

var timeSinceNow = TimeInterval(0)
var secondsSinceNow = 0
var minutesSinceNow = 0

var completionTime = TimeInterval(0)
var completionSeconds = 0
var completionMinutes = 0


// MARK: - Map Tiling
let columns = 64
let rows = 64



// MARK: - Collectibles
var collectibleSet = CollectibleSet()
let totalCollectibles = 6
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



// MARK: - Notifications
let progressUpdate = Notification.Name("com.progress")
let victoryToShare = Notification.Name("com.victory")


// MARK: - Screen Size

let screenSize = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


// MARK: - Scene Information
var currentScene = ""
