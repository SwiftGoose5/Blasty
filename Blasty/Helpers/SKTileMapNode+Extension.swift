//
//
//
// Created by Swift Goose on 5/31/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation
import SpriteKit

extension SKTileMapNode {
    func eraseTileSet() {
        let blankGroup: [SKTileGroup] = []
        let blankTileSet = SKTileSet(tileGroups: blankGroup)
        tileSet = blankTileSet
    }
}
