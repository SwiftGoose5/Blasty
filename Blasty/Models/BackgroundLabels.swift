//
//
//
// Created by Swift Goose on 4/12/22 AT 4:47 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class BackgroundLabels: SKNode {
    
    var westLabel = SKLabelNode()
    var eastLabel = SKLabelNode()
    var northLabel = SKLabelNode()
    var southLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        westLabel.text = "NOTHING TO SEE HERE ..."
        eastLabel.text = "NOTHING TO SEE HERE EITHER ..."
        northLabel.text = "🚀🌝 TO THE MOON !? 🚀🌝"
        southLabel.text = "GRAVITY HURTS ..."
        
        westLabel.fontSize = 200
        eastLabel.fontSize = 200
        northLabel.fontSize = 200
        southLabel.fontSize = 200
        
        westLabel.zPosition = -2
        eastLabel.zPosition = -2
        northLabel.zPosition = -2
        southLabel.zPosition = -2
        
        westLabel.position = CGPoint(x: -9000, y: 0)
        eastLabel.position = CGPoint(x: 9000, y: 0)
        northLabel.position = CGPoint(x: 0, y: 5000)
        southLabel.position = CGPoint(x: 0, y: -6000)
        
        addChild(westLabel)
        addChild(eastLabel)
        addChild(northLabel)
        addChild(southLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
