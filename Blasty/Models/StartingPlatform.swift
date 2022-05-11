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
    private var centerSecondUnderLabelNode = SKLabelNode()
    private var rightLabelNode = SKLabelNode()
    
    override init() {
        super.init()
        
        removeAllChildren()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StartingPlatform {
    func buildPlatform(isStart: Bool = false) {

        let loadData = UserDefaults.standard
        wasVictory = loadData.bool(forKey: "wasVictory")
        isDayComplete = loadData.bool(forKey: "isDayComplete")
        
        if isStart {
            leftLabelNode.fontName = "Helvetica Neue Bold"
            leftLabelNode.text = "Hold left to aim"
            leftLabelNode.fontSize = 110
            leftLabelNode.position = CGPoint(x: -1100, y: -400)
            
            if isDayComplete {
                centerLabelNode.fontName = "Helvetica Neue Bold"
                centerLabelNode.text = "Next Challenge Available In:"
                centerLabelNode.fontSize = 150
                centerLabelNode.position = CGPoint(x: 0, y: 700)
                
                if wasVictory {
                    centerSecondUnderLabelNode.fontName = "Helvetica Neue Bold"
                    centerSecondUnderLabelNode.fontSize = 100
                    centerSecondUnderLabelNode.position = CGPoint(x: 0, y: 300)
                    
                    completionTime = UserDefaults.standard.double(forKey: "completionTime")
                    
                    completionSeconds = Int(completionTime) % 3600 % 60
                    completionMinutes = Int(completionTime) % 3600 / 60
                    
                    let seconds = completionSeconds < 10 ? "0\(completionSeconds)" : String(completionSeconds)
                    let minutes = completionMinutes < 10 ? "0\(completionMinutes)" : String(completionMinutes)
                    
                    centerSecondUnderLabelNode.text = "Today's Score: \(minutes) : \(seconds)"

                    addChild(centerSecondUnderLabelNode)
                } else {
                    centerSecondUnderLabelNode.fontName = "Helvetica Neue Bold"
                    centerSecondUnderLabelNode.fontSize = 100
                    centerSecondUnderLabelNode.color = .orange
                    centerSecondUnderLabelNode.position = CGPoint(x: 0, y: 250)
                    
                    centerSecondUnderLabelNode.text = "Better luck next time!"

                    addChild(centerSecondUnderLabelNode)
                }
            } else {
                centerLabelNode.fontName = "Helvetica Neue Bold"
                centerLabelNode.text = "Loading Today's Challenge"
                centerLabelNode.fontSize = 150
                centerLabelNode.position = CGPoint(x: 0, y: 700)
            }
            
            rightLabelNode.fontName = "Helvetica Neue Bold"
            rightLabelNode.text = "Touch/Hold right to jump"
            rightLabelNode.fontSize = 110
            rightLabelNode.position = CGPoint(x: 1100, y: -400)
            
            addChild(leftLabelNode)
            addChild(rightLabelNode)
            
        } else {
            centerLabelNode.fontName = "Helvetica Neue Bold"
            centerLabelNode.text = "^^ Activate the Portal ^^"
            centerLabelNode.fontSize = 150
            centerLabelNode.position = CGPoint(x: 0, y: -5000)
            
            centerUnderLabelNode.fontName = "Helvetica Neue Bold"
            centerUnderLabelNode.text = "Be careful of the mustard :>"
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


