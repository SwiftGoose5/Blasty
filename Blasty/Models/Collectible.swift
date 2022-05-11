//
//
//
// Created by Swift Goose on 4/11/22 AT 4:32 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//



import SpriteKit


struct CollectibleSet {
    var collectibles: [Collectible] = []
    
    init() {
        let coordinateSet = RNGFactory.coordinateSet
        
        for i in 0 ..< totalCollectibles - 1 {
//            let collectible = Collectible(at: coordinateSet[i])
            let collectible = Collectible()
            collectible.index = i
            collectibles.append(collectible)
        }
        
        let constantCollectible = Collectible(at: [0,0])
        constantCollectible.index = 5
        constantCollectible.position = CGPoint(x: 0, y: -5784)
        
        collectibles.append(constantCollectible)
    }
}

class Collectible: SKSpriteNode {
    
    let cTexture = SKTexture(imageNamed: "Collectible")
    
    var emitter = SKEmitterNode()
    var coords: [Int] = []
    var index: Int = 0
    var wasPickedUp = false
    
    init(at coords: [Int] = []) {
        self.coords = coords
        
        super.init(texture: cTexture, color: .white, size: cTexture.size())
        physicsBody = SKPhysicsBody(texture: cTexture, size: cTexture.size())
        
        setupCollectible()
    }
    
    private func setupCollectible() {
        physicsBody?.categoryBitMask = CollisionType.collectible.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue

        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = true
        
        emitter = SKEmitterNode(fileNamed: "CollectibleParticle")!
        emitter.particleColor = .white
        emitter.zPosition = -1
        
        addChild(emitter)
        
        let seq = SKAction.sequence([.scale(to: 1.2, duration: 1),
                                     .scale(to: 1.0, duration: 1)])
        
        run(.repeatForever(seq))
    }
    
    func collect(_ soundIndex: Int) {
        var soundFile = ""

        switch soundIndex {
        case 0:
            soundFile = "flute_g.m4a"
        case 1:
            soundFile = "flute_a.m4a"
        case 2:
            soundFile = "flute_b.m4a"
        case 3:
            soundFile = "flute_c.m4a"
        case 4:
            soundFile = "flute_d.m4a"
        case 5:
            soundFile = "flute_complete.m4a"
        default:
            break
        }
        
        let sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        let blowup = SKAction.scale(to: 1.4, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let group = SKAction.group([sound, blowup, fade])
        run(group)
        run(.removeFromParent())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
