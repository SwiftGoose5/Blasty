//
//
//
// Created by Swift Goose on 3/31/22 AT 2:02 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class TerrainNode: SKSpriteNode {
    init(size: CGSize, pos: CGPoint, rot: CGFloat) {
        let texture = SKTexture(imageNamed: "grass")
        
        super.init(texture: texture, color: .white, size: CGSize(width: size.width, height: size.height))
        
        name = "terrain"

        position = pos
        zRotation = rot
        
        physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: size.width, height: size.height))
        
        physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue

        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.4
        physicsBody?.friction = 0.2
        physicsBody?.angularDamping = 0.2
        physicsBody?.linearDamping = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
