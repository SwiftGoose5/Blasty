//
//
//
// Created by Swift Goose on 4/6/22 AT 2:39 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import GameplayKit

struct RNGFactory {
    
    static var colRow: [Int] {
        var arr = [Int]()
        
        let rs = GKMersenneTwisterRandomSource()
        rs.seed = UInt64(DateFactory.dateSeed)
        
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 127)
        
        for _ in 0 ..< 2 {
            arr.append(rd.nextInt())
        }
        
        return arr
    }
}
