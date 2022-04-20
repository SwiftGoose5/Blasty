//
//
//
// Created by Swift Goose on 4/18/22 AT 4:13 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit


class PracticeScene: SKScene {
    var player: PlayerNode?
    
    var backgroundLabels = BackgroundLabels()

    var joystick : Joystick?
    var joystickActive = false
    var joystickData = JoystickData()
    
    var button : Button?
    var buttonData = ButtonData()
    
    var lastCollectibleIndex = -1
    
    var lastSpikeHit = ""
    
    var launcher: LauncherParentNode?
    
    let sceneCamera = SKCameraNode()
    
    let map = SKNode()
    let mapFactory = MapFactory()
    
    let skyFactory = SkyFactory()
    var cloud1 = SKSpriteNode()
    let cloud1Speed = CGFloat(0.3)
    
    let portalSwitch = Collectible()
    let portal = BlackHole()

    
    var startingPlatform = StartingPlatform()
    
    override func didMove(to view: SKView) {
        
        SKTextureAtlas(named: "Grid Tile Sprite Atlas").preload {
            
        }

        
        startingPlatform.buildPlatform()
        addChild(startingPlatform)
        addChild(backgroundLabels)
        
        
        let cloud1Texture = SKTexture(imageNamed: "Cloud1")
        cloud1 = SKSpriteNode(texture: cloud1Texture, size: cloud1Texture.size())
        cloud1.setScale(20)
        cloud1.zPosition = -4
        cloud1.alpha = 0.2

        addChild(cloud1)
        addChild(skyFactory)
        
        
        // MARK: - Physics Delegate
        scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        backgroundColor = .purple
        
        
        // MARK: - Joystick
        joystick = Joystick()
        addChild(joystick!)
        
        // MARK: - Button
        button = Button()
//        addChild(button!)

        
        // MARK: - Player
        player = PlayerNode()
        player!.position = CGPoint(x: 0, y: mapFactory.position.y - 5368)
        addChild(player!)
        
        
        // MARK: - Launcher
        launcher = LauncherParentNode()
        addChild(launcher!)
        
        
        // MARK: - Camera
        scene?.addChild(sceneCamera)
        scene?.camera = sceneCamera
        sceneCamera.setScale(3)
        
        
        // MARK: - Portal and Switch
        portalSwitch.index = -4
        addChild(portalSwitch)

        
        // MARK: - Map
        addChild(mapFactory)
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    joystickActive = true
                }
            }

            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
                    button!.isPressed = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)

            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    // We're touching the left side of the screen
                    joystickData = joystick!.moveStick(jsLocation: joystick!.position, touchLocation: location)
                    
                    joystick?.setBaseAlpha(joystickData.strength)
                    joystick?.setBaseScale(joystickData.strength)
                    
                    launcher!.setLauncherAlpha(joystickData.strength)
                    launcher!.setLauncherScale(joystickData.strength)
                    launcher!.setLauncherAngle(joystickData.angle)
                    launcher!.setEmitterStrength(joystickData.strength)
                }
            }

            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
                    // Button being held
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            launcher?.setLauncherAlpha(0)
            launcher?.resetEmitter()

            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    joystickActive = false
                    joystick!.centerStick()
                    joystick!.resetBaseAlpha()
                    joystick!.resetBaseScale()
                }
            }

            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {

                    if !button!.isPressed { continue }
                    
                    player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * buttonData.strength,
                                                               dy: joystickData.vector.dy * buttonData.strength))
                    
                    button!.isPressed = false
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick!.centerStick()
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        
        if button!.isPressed {
            buttonData.startTime = currentTime
        } else {
            buttonData.endTime = currentTime
        }

        if abs(player!.position.x) > 10000 || abs(player!.position.y) > 10000 {
            player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player?.position = CGPoint(x: 0, y: -5300)
        }

        joystick?.position.x = player!.position.x - frame.width / 1.25
        joystick?.position.y = player!.position.y - frame.height / 2.5
        
        button?.position.x = player!.position.x + frame.width / 1.25
        button?.position.y = player!.position.y - frame.height / 2.5
        
        launcher?.position = player!.position
        sceneCamera.position = player!.position
        
        cloud1.position.x = player!.position.x + player!.position.x * -cloud1Speed
        cloud1.position.y = player!.position.y + player!.position.y * -cloud1Speed

        skyFactory.position.x = player!.position.x + player!.position.x * -cloud1Speed
        skyFactory.position.y = player!.position.y + player!.position.y * -cloud1Speed
        
        backgroundLabels.position.y = player!.position.y + player!.position.y * -cloud1Speed
    }
}

// MARK: - Physics Delegate

extension PracticeScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        print("contact between \(firstNode.name) and \(secondNode.name)")

        if let player = firstNode as? PlayerNode, let _ = secondNode.name?.contains("spikes") {
            
            // don't hit the same spike more than once
            if lastSpikeHit == secondNode.name! { return }
            
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.run(SKAction.move(to: CGPoint(x: 0, y: mapFactory.position.y - 5300), duration: 0))

            lastSpikeHit = secondNode.name!
        }
        
        
        if let collectible = firstNode as? Collectible {
            
            // don't hit the same collectible more than once
            if lastCollectibleIndex == collectible.index { return }
            
            // "5" is complete sound
            collectible.collect(5)

            lastCollectibleIndex = collectible.index
            
            portal.setScale(0)
            portal.position = collectible.position
            portal.run(SKAction.scale(to: 40, duration: 5))
            addChild(portal)
            
            // TP back
        }
        
        if let blackHole = firstNode as? BlackHole, let player = secondNode as? PlayerNode {
            blackHole.field?.isEnabled = false
            player.physicsBody?.collisionBitMask = 0
            player.physicsBody?.contactTestBitMask = 0
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.run(SKAction.move(to: blackHole.position, duration: 1))
        }
    }
}
