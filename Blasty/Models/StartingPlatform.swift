//
//
//
// Created by Swift Goose on 4/11/22 AT 12:48 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class StartingPlatform: SKNode {
    
    private let centerTexture = SKTexture(imageNamed: "Cobblestone_Grid_Center")
    private let bottomTexture = SKTexture(imageNamed: "Cobblestone_Grid_Down")
    
    private var centerNodes: [Platform?] = []
    private var bottomNodes: [Platform?] = []
    
    private var leftLabelNode = SKLabelNode()
    private var centerLabelNode = SKLabelNode()
    private var centerUnderLabelNode = SKLabelNode()
    private var rightLabelNode = SKLabelNode()
    
    override init() {
        super.init()
        
        buildPlatform()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StartingPlatform {
    func buildPlatform() {
        leftLabelNode.text = "Left stick steers!"
        leftLabelNode.fontSize = 120
        leftLabelNode.position = CGPoint(x: -1000, y: -5500)
        
        centerLabelNode.text = "^^ Find the Black Hole! ^^"
        centerLabelNode.fontSize = 150
        centerLabelNode.position = CGPoint(x: 0, y: -5000)
        
        centerUnderLabelNode.text = "Mind the grass please :>"
        centerUnderLabelNode.fontSize = 100
        centerUnderLabelNode.position = CGPoint(x: 0, y: -4400)
        
        rightLabelNode.text = "Right stick jumps!"
        rightLabelNode.fontSize = 120
        rightLabelNode.position = CGPoint(x: 1000, y: -5500)
        
        for index in -2 ... 2 {
            centerNodes.append(Platform(with: centerTexture))
            centerNodes[index+2]!.position = CGPoint(x: 0 + (128 * index), y: -5496)
            
            bottomNodes.append(Platform(with: bottomTexture))
            bottomNodes[index+2]!.position = CGPoint(x: 0 + (128 * index), y: -5624)
            
            addChild(centerNodes[index+2]!)
            addChild(bottomNodes[index+2]!)
        }
        
        addChild(leftLabelNode)
        addChild(centerLabelNode)
        addChild(centerUnderLabelNode)
        addChild(rightLabelNode)
    }
}

extension StartingPlatform {
    class Platform: SKSpriteNode {
        
        init(with texture: SKTexture) {
            super.init(texture: texture, color: .white, size: texture.size())
            
            physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
            physicsBody?.isDynamic = false
            physicsBody?.affectedByGravity = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


