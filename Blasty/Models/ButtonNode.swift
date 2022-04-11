//
//
//
// Created by Swift Goose on 4/8/22 AT 2:45 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//

import SpriteKit

struct ButtonData {
    let maxTime : Double = 3.0
    var startTime : Double
    var endTime : Double
    
    var strength : Double {
        return (endTime - startTime) / maxTime * 24
    }
    
    init(_ startTime: Double = 0, _ endTime: Double = 0) {
        self.startTime = startTime
        self.endTime = endTime
    }
}


class Button : SKNode {
    
    private var baseScale: CGFloat = 1
    private var baseAlpha: CGFloat = 1
    
    var isPressed = false
    
    private var button: SKSpriteNode
    
    override init() {
        button = SKSpriteNode(imageNamed: "Joystick")
        
        super.init()
        
        button.zPosition = 2
        button.isUserInteractionEnabled = true

        addChild(button)
    }
    
    func pressButton(at startTime: CGFloat) -> ButtonData {
        return ButtonData(startTime)
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
