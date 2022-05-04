//
//
//
// Created by Swift Goose on 3/31/22 AT 1:12 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class LauncherParentNode: SKNode {
    
    private var launcher: SKShapeNode?
    private var launcherNode: LauncherNode?

    var launcherEmitter: SKEmitterNode
    private var emitterBirthRate = CGFloat(1200)
    private var emitterSpeed = CGFloat(1200)
    
    private var lengthScaleFactor = CGFloat(10.0)
    
    override init() {
        
        launcherEmitter = SKEmitterNode(fileNamed: "LauncherParticle")!
        launcherEmitter.alpha = 0
        
        super.init()
        
        for child in self.children {
            child.removeFromParent()
        }
        
        name = "launcherParent"
        zPosition = 2
        alpha = 1
        position = CGPoint(x: 0, y: 0)
        
        addChild(launcherEmitter)
        
        
        launcher = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 15, height: 30), cornerRadius: 8)
        launcher?.alpha = 0.5
        launcher?.zPosition = -1
//        addChild(launcher!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetEmitter() {
        launcherEmitter.particleBirthRate = emitterBirthRate
        launcherEmitter.speed = emitterSpeed
    }
    
    func setEmitterStrength(_ strength: CGFloat) {
        launcherEmitter.particleBirthRate = emitterBirthRate * strength
        launcherEmitter.speed = emitterSpeed * strength
    }
    
    func setLauncherAngle(_ angle: CGFloat) {
        launcher!.zRotation = angle + .pi/2
        launcherEmitter.zRotation = angle - .pi/2
    }
    
    func setLauncherScale(_ strength: CGFloat) {
        launcher!.yScale = strength * lengthScaleFactor
    }
    
    func setLauncherAlpha(_ alpha: CGFloat) {
        launcher!.alpha = alpha
        launcherEmitter.alpha = alpha
    }
    
    
}

class LauncherNode: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "launcherBase")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "launcherBase"
        zPosition = 2
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

