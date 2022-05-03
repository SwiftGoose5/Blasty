//
//
//
// Created by Swift Goose on 4/13/22 AT 11:11 AM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class PlayerCollectibles: SKNode {
    
    private let texture = SKTexture(imageNamed: "Collectible")
    
    private var collectibles: [SKSpriteNode] = []
    private var collectiblesContainer: [SKShapeNode] = []
    
    private var circlePoints: [CGPoint] = []
    
    var width = CGFloat(0)
    var height = CGFloat(0)
    
    override init() {
        
        super.init()
        
        circlePoints = getCirclePoints(centerPoint: self.position, radius: texture.size().width * 5, n: Double(totalCollectibles))

        for index in 0 ..< totalCollectibles {
            let collectible = SKSpriteNode(texture: texture, size: texture.size())
            
            collectible.name = "collectible\(index)"
            collectible.zPosition = 10
            collectible.alpha = 0
            collectible.setScale(0)
            collectibles.append(collectible)
            
            addChild(collectible)
//            collectible.position = CGPoint(x: CGFloat(index) * texture.size().width, y: 0)
            collectible.position = circlePoints[index]
            
            
            // fill the containers behind
            let container = SKShapeNode(circleOfRadius: texture.size().width / 4 + 10)
            
            container.name = "collectibleContainer\(index)"
            container.zPosition = 9
            container.fillColor = .black
            container.strokeColor = .black
            container.alpha = 0.7
            collectiblesContainer.append(container)
            
            
            addChild(container)
//            container.position = CGPoint(x: CGFloat(index) * texture.size().width, y: 0)
            container.position = circlePoints[index]
        }
        
        width = calculateAccumulatedFrame().width
        height = calculateAccumulatedFrame().height
        
        run(.repeatForever(.rotate(byAngle: 1, duration: 10)))
    }
    
    func updateScore() {
        
        let current = collectibles[collectibleCount - 1]
        current.run(SKAction.scale(to: 2.5, duration: 0))
        
        let appear = SKAction.fadeIn(withDuration: 0.3)
        let blowdown = SKAction.scale(to: 0.5, duration: 0.4)
        let group = SKAction.group([appear, blowdown])
        
        current.run(group)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

