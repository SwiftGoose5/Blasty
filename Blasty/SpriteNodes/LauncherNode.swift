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
    private var launcherTip: LauncherTipNode?
    var launcherEmitter: SKEmitterNode?
    
    private var lengthScaleFactor = CGFloat(10.0)
    
    override init() {
        super.init()
        
        name = "launcherParent"
        zPosition = 2
        alpha = 1
        position = CGPoint(x: 0, y: 0)
        
//        launcherNode = LauncherNode()
        
        launcherEmitter = SKEmitterNode(fileNamed: "LauncherParticle")
        addChild(launcherEmitter!)
        
        
        launcher = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 15, height: 30), cornerRadius: 8)
        launcher?.fillColor = .white
        launcher?.alpha = 0.5
        launcher?.zPosition = -1
        
//        launcherTip = LauncherTipNode()
//        launcherNode?.addChild(launcherTip!)
        
        addChild(launcher!)
//        addChild(launcherNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLauncherAngle(_ angle: CGFloat) {
        launcher!.zRotation = angle + .pi/2
        launcherEmitter!.zRotation = angle - .pi/2
    }
    
    func setLauncherScale(_ strength: CGFloat) {
        launcher!.yScale = strength * lengthScaleFactor
//        launcherTip?.updatePosition(strength / lengthScaleFactor)
    }
    
    func setLauncherAlpha(_ alpha: CGFloat) {
        launcher!.alpha = alpha
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

class LauncherTipNode: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "launcherTip")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "launcherTip"
        zPosition = 3
        alpha = 1
//        xScale = 4
//        yScale = 4
//        position = CGPoint(x: texture.size().width / 2, y: texture.size().height / 2)
//        position = CGPoint(x: 0, y: 0)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func updatePosition(_ scale: CGFloat) {
        yScale /= scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
