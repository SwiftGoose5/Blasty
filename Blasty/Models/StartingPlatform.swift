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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StartingPlatform {
    func buildPlatform(isStart: Bool = false) {
        
        if isStart {
            leftLabelNode.text = "This side aims"
            leftLabelNode.fontSize = 120
            leftLabelNode.position = CGPoint(x: -1100, y: 0)
            
            centerLabelNode.text = "Loading Today's Challenge"
            centerLabelNode.fontSize = 150
            centerLabelNode.position = CGPoint(x: 0, y: 600)
            
            centerUnderLabelNode.text = "Next Challenge Available: "
            centerUnderLabelNode.fontSize = 100
            centerUnderLabelNode.position = CGPoint(x: 0, y: 400)
            addChild(centerUnderLabelNode)
            
            rightLabelNode.text = "This side jumps"
            rightLabelNode.fontSize = 120
            rightLabelNode.position = CGPoint(x: 1100, y: 0)
            
            addChild(leftLabelNode)
            addChild(rightLabelNode)
            
        } else {
            centerLabelNode.text = "^^ Activate the Portal ^^"
            centerLabelNode.position = CGPoint(x: 0, y: -5000)
            
            centerUnderLabelNode.text = "Mind the green grass please :>"
            centerUnderLabelNode.fontSize = 120
            centerUnderLabelNode.position = isStart ? CGPoint(x: 0, y: 1200) : CGPoint(x: 0, y: -4400)
            addChild(centerUnderLabelNode)
        }
        
        addChild(centerLabelNode)
        
        if isStart { return }
        
        for index in -2 ... 2 {
            centerNodes.append(Platform(with: centerTexture))
            centerNodes[index+2]!.position = isStart ? CGPoint(x: 0 + (128 * index), y: 0) : CGPoint(x: 0 + (128 * index), y: -5496)
            
            bottomNodes.append(Platform(with: bottomTexture))
            bottomNodes[index+2]!.position = isStart ? CGPoint(x: 0 + (128 * index), y: -128) : CGPoint(x: 0 + (128 * index), y: -5624)
            
            addChild(centerNodes[index+2]!)
            addChild(bottomNodes[index+2]!)
        }
        
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


