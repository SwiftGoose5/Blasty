//
//
//
// Created by Swift Goose on 4/12/22 AT 5:04 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class PlayerLives: SKNode {
    
    private let texture = SKTexture(imageNamed: "PlayerBall")
    
    private var lives: [SKSpriteNode] = []
    private var livesContainer: [SKShapeNode] = []
    
    
    override init() {
        
        super.init()

        for index in 0 ..< totalLives {
            let life = SKSpriteNode(texture: texture, size: texture.size())
            
            life.name = "life\(index)"
            life.zPosition = 10
            life.setScale(1)
            lives.append(life)
            
            addChild(life)
            life.position = CGPoint(x: CGFloat(index) * texture.size().width * 2, y: 0)
            
            
            // fill the containers behind
            let container = SKShapeNode(circleOfRadius: texture.size().width / 2 + 10)
            
            container.name = "lifeContainer\(index)"
            container.zPosition = 9
            container.fillColor = .black
            container.strokeColor = .black
            container.alpha = 0.7
            livesContainer.append(container)
            
            addChild(container)
            container.position = CGPoint(x: CGFloat(index) * texture.size().width * 2, y: 0)
        }
    }
    
    func updateLives() {
        let soundFile = "pop.m4a"
        
        let current = lives[lifeCount - 1]

        let sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        let blowup = SKAction.scale(to: 2.5, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([blowup, fade])
        let seq = SKAction.sequence([sound, group, .removeFromParent()])
        
        current.run(seq)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
