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
        
        removeAllChildren()
        
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
        
        alpha = 0.8
        
        let animation = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.run(.repeatForever(.rotate(byAngle: 1, duration: 10)))
        }
        animation()
    }
    
    func updateScore() {
        
        let current = collectibles[collectibleCount - 1]
        current.run(SKAction.scale(to: 5, duration: 0))
        
        let appear = SKAction.fadeIn(withDuration: 0.3)
        let blowdown = SKAction.scale(to: 0.5, duration: 0.4)
        let group = SKAction.group([appear, blowdown])
        
        current.run(group)
        
        let rotate = SKAction.rotate(byAngle: 4, duration: 1.5)
        rotate.timingMode = .easeInEaseOut
        run(rotate)
    }
    
    func moveToBlackHoleLocation(_ location: CGPoint) {
        
        let move = SKAction.move(to: location, duration: 3)
        let rotate = SKAction.rotate(byAngle: 4, duration: 2)
        let fade = SKAction.fadeOut(withDuration: 3)
        let seq = SKAction.sequence([move, rotate, fade, .removeFromParent()])
        run(seq)
    }
    
    func moveToBlackHoleLocation(_ node: SKNode) {
        
        
        move(toParent: node.parent!)
        
        
//        print(node.position)
//        let newLocation = node.convert(node.position, to: self)
//        let otherLocation = convert(node.position, from: node)
//        let sceneLocation = convert(node.position, to: scene!)
//
//        let myScene = self.convert(position, to: scene!)
//
//        print(newLocation)
//        print(otherLocation)
//        print(sceneLocation)
//        print(myScene)

        let move = SKAction.move(to: node.position, duration: 3)
        move.timingMode = .easeIn
        let scale = SKAction.scale(to: 1.2, duration: 3)
        let rotate = SKAction.rotate(byAngle: 4, duration: 3)
        rotate.timingMode = .easeIn
        let seq = SKAction.group([move, rotate, scale])
        run(seq)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

