//
//
//
// Created by Swift Goose on 4/3/22 AT 4:32 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

struct JoystickData {
    var angle : CGFloat
    var strength : CGFloat
    var vector : CGVector
    
    init(_ angle: CGFloat = 0, _ strength: CGFloat = 0, _ vector: CGVector = CGVector(dx: 0, dy: 0)) {
        self.angle = angle
        self.strength = strength
        self.vector = vector
    }
}

class Joystick : SKNode {
    
    private let baseRadius: CGFloat = 200
    private var baseAlpha: CGFloat = 0
    private var baseFillAlpha: CGFloat = 0.3
    
    private var base: SKShapeNode
    private var baseFill: SKShapeNode
    private var stick: SKSpriteNode
    
    override init() {
        base = SKShapeNode(circleOfRadius: baseRadius)
        baseFill = SKShapeNode(circleOfRadius: baseRadius)
        stick = SKSpriteNode(imageNamed: "Joystick")
        
        super.init()
        
        base.zPosition = 2
        base.fillColor = .orange
        base.strokeColor = .clear
        base.alpha = baseAlpha
        base.setScale(0)
        
        baseFill.zPosition = 1
        baseFill.fillColor = .black
        baseFill.strokeColor = .clear
        baseFill.alpha = baseFillAlpha
        
        stick.zPosition = 2

        addChild(base)
        addChild(baseFill)
        addChild(stick)
    }
    
    func moveStick(jsLocation: CGPoint, touchLocation: CGPoint) -> JoystickData {
        
        var vector = CGVector(dx: touchLocation.x - jsLocation.x, dy: touchLocation.y - jsLocation.y)
        
        var angle = atan(vector.dy / vector.dx)
        var strength = CGFloat(0.0)
        
        let vLength = length(vector.dx, vector.dy)
        
        // We're outside the base's frame
        if vLength > baseRadius {
            
            var newX = baseRadius * cos(angle)
            var newY = baseRadius * sin(angle)
            
            if vector.dx < 0 {
                
                newX *= -1
                newY *= -1
                
                if angle < 0 {
                    angle = .pi + angle
                } else {
                    angle = -.pi + angle
                }
            }
            
            vector.dx = newX
            vector.dy = newY
            
            stick.position = CGPoint(x: newX, y: newY)
            strength = CGFloat(1.0)
            
        } else {

            if vector.dx < 0 {
                if angle > 0 {
                    angle = .pi + angle
                } else {
                    angle = -.pi + angle
                }
            }
            
            stick.position.x = vector.dx
            stick.position.y = vector.dy
            
            strength = distance(jsLocation, touchLocation) / baseRadius
        }

        return JoystickData(angle, strength, vector)
    }
    
    
    func centerStick() {
//        stick.position = CGPoint(x: 0, y: 0)
        stick.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.02))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Joystick {
    
    func setBaseScale(_ scale: CGFloat) {
        base.setScale(scale)
    }
    
    func resetBaseScale() {
        base.setScale(0)
    }
    
    func setBaseAlpha(_ alpha: CGFloat) {
        base.alpha = alpha
    }
    
    func resetBaseAlpha() {
        base.alpha = baseAlpha
        baseFill.alpha = baseFillAlpha
    }
}
