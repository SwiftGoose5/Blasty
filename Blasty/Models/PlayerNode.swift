//
//
//
// Created by Swift Goose on 3/31/22 AT 1:07 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class PlayerNode: SKSpriteNode {
    

    var isMoving = false
    
    init() {
        let texture = SKTexture(imageNamed: "PlayerBall")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "player"
        position = CGPoint(x: 0, y: 0)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 4
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.victory.rawValue  | CollisionType.spikes.rawValue
        physicsBody?.contactTestBitMask = CollisionType.ground.rawValue | CollisionType.victory.rawValue  | CollisionType.spikes.rawValue
        physicsBody?.fieldBitMask = CollisionType.field.rawValue
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.2
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

