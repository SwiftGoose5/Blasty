//
//
//
// Created by Swift Goose on 4/6/22 AT 11:03 AM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class BlackHole: SKSpriteNode {
    
    var emitter: SKEmitterNode?
    var field: SKFieldNode?
    
    init() {
        let texture = SKTexture(imageNamed: "BlackHole")
        let scale = 1.5
        
    
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "BlackHole"
        setScale(scale)
        
        physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: size.width, height: size.height))
        
        physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue

        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.mass = 1000
        
        emitter = SKEmitterNode(fileNamed: "BlackHole")!
        emitter!.alpha = 0.5
//        emitter!.zPosition = -1
        addChild(emitter!)
        
        
        field = SKFieldNode.radialGravityField()
        field!.strength = 20
        field!.isEnabled = true
        field!.categoryBitMask = CollisionType.field.rawValue
        addChild(field!)
        
        run(SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 1)))
        
        // cool blow up effect
//        run(SKAction.repeatForever(SKAction.scale(by: CGFloat.random(in: 0...2.0), duration: 1)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

