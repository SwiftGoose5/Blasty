//
//
//
// Created by Swift Goose on 5/9/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit


//extension SKScene {
//    func removeSceneChildrenRecursively() {
//        for child in children {
//            child.removeFromParent()
//            removeChildrenRecursively()
//        }
//    }
//}

extension SKNode {
    func removeChildrenRecursively() {
        for child in children {
            if child.physicsBody != nil { child.physicsBody = nil }
            child.removeAllActions()
            child.removeFromParent()
            removeChildrenRecursively()
        }
    }
}
