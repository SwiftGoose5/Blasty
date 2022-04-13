//
//
//
// Created by Swift Goose on 4/12/22 AT 3:04 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class Score: SKNode {
    
    var label = SKLabelNode()
    let texture = SKTexture(imageNamed: "Collectible")
    var icon = SKSpriteNode()
    
    override init() {
        super.init()
        
        label.text = "\(collectibleCount) of 6"
        label.fontSize = 110
        label.fontName = "Helvetica Neue"
        
        icon = SKSpriteNode(texture: texture, size: texture.size())
        label.addChild(icon)
        
        label.position = CGPoint(x: 0, y: frame.height - 40)
        icon.position = CGPoint(x: 230, y: 45)
        
        addChild(label)
    }
    
    func updateScore() {
        
        label.fontName = (collectibleCount == 6 ? "Helvetica Neue Bold" : "Helvetica Neue")
        
        label.text = "\(collectibleCount) of 6"
        
        if collectibleCount == 6 {
            run(SKAction.scale(to: 1.5, duration: 1))
            run(SKAction.scale(to: 1.0, duration: 1))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
