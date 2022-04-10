//
//
//
// Created by Swift Goose on 4/8/22 AT 2:45 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//

import SpriteKit
class Button : SKNode {
    
    private var baseScale: CGFloat = 1
    private var baseAlpha: CGFloat = 1
    
    private var button: SKSpriteNode
    
    override init() {
        button = SKSpriteNode(imageNamed: "Joystick")
        
        super.init()
        
        button.zPosition = 2
        button.isUserInteractionEnabled = true

        addChild(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button {
    
    func setButtonScale(_ scale: CGFloat) {
        button.setScale(scale)
    }
    
    func resetButtonScale() {
        button.setScale(baseScale)
    }
    
    func setButtonAlpha(_ alpha: CGFloat) {
        button.alpha = alpha
    }
    
    func resetBaseAlpha() {
        button.alpha = baseAlpha
    }
}
