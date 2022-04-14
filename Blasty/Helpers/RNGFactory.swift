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
        
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: columns - 1)
        
        for _ in 0 ..< 2 {
            arr.append(rd.nextInt())
        }
        
        return arr
    }
    
    static var coordinateSet: [[Int]] {
        var set = [[Int]]()
        var coordinate = [Int]()
        
        let source = GKMersenneTwisterRandomSource()
        
        // Make from 1 - 5 because 0 is the location of the black hole
        for i in 1 ... 5 {
            source.seed = UInt64(DateFactory.dateSeed + Int32(i))
            
            let distribution = GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: columns - 1)
            
            for _ in 0 ... 1 {
                coordinate.append(distribution.nextInt())
            }
            
            set.append(coordinate)
            
            coordinate = [Int]()
        }

        return set
    }
    
    static func getSingleAvailablePoint(_ index: Int, _ highestValue: Int) -> Int {
        let source = GKMersenneTwisterRandomSource()
        var coordinate = [Int]()
        
        source.seed = UInt64(DateFactory.dateSeed + Int32(index + 1))
        
        let distribution = GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: highestValue - 1)
        
        return distribution.nextInt()
//        for _ in 0 ... 1 {
//            coordinate.append(distribution.nextInt())
//        }
//        
//        return coordinate
    }
}
