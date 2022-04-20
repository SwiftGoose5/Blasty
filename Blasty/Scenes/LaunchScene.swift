//
//
//
// Created by Swift Goose on 4/18/22 AT 1:56 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit


class LaunchScene: SKScene {
    
    var player = PlayerNode()
    
    var startingPlatform = StartingPlatform()
    
    var portal = BlackHole()
    var portalLabel = SKLabelNode()

    var joystick = Joystick()
    var joystickActive = false
    var joystickData = JoystickData()
    
    var button = Button()
    var buttonData = ButtonData()
    
    var launcher = LauncherParentNode()
    
    let sceneCamera = SKCameraNode()
    
    let skyFactory = SkyFactory()
    var cloud1 = SKSpriteNode()
    let cloud1Speed = CGFloat(0.3)
    
    var dailyScene = SKScene()
    
    let progressTexture = SKTexture(imageNamed: "ProgressBar")
    let progressContainerTexture = SKTexture(imageNamed: "ProgressBarContainer")
    var progressBar = SKSpriteNode()
    var progressContainer = SKSpriteNode()
    var progressCount = CGFloat(1)
    var progressBarMaxScale = CGFloat(10)
    
    override func didMove(to view: SKView) {
        
        // MARK: - Progress Bar
        progressContainer = SKSpriteNode(texture: progressContainerTexture, size: progressContainerTexture.size())
        progressContainer.physicsBody = SKPhysicsBody(texture: progressContainerTexture, size: progressContainerTexture.size())
        progressContainer.physicsBody?.affectedByGravity = false
        progressContainer.physicsBody?.isDynamic = false
        progressContainer.xScale = 21
        progressContainer.yScale = 2.8
        
        progressBarMaxScale = 20
        
        progressBar = SKSpriteNode(texture: progressTexture, size: progressTexture.size())
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBar.position = CGPoint(x: -progressTexture.size().width / 2 * progressBarMaxScale, y: 0)
        progressBar.xScale = 0
        progressBar.yScale = 2
        
        addChild(progressContainer)
        addChild(progressBar)
        
        // MARK: - Cloud
        let cloud1Texture = SKTexture(imageNamed: "Cloud1")
        cloud1 = SKSpriteNode(texture: cloud1Texture, size: cloud1Texture.size())
        cloud1.setScale(20)
        cloud1.zPosition = -4
        cloud1.alpha = 0.2
        
        startingPlatform.buildPlatform(isStart: true)
        addChild(startingPlatform)
        
        addChild(skyFactory)
        addChild(cloud1)
        
        // MARK: - Black Hole Switches
        portalLabel.text = "Daily Challenge"
        portalLabel.fontName = "Helvetica Neue Bold"
        portalLabel.fontSize = 140
        portalLabel.position = CGPoint(x: 0, y: 2400)
        addChild(portalLabel)
        
        

        // MARK: - Physics Delegate
        scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        backgroundColor = .blue
        
        
        // MARK: - Joystick
        addChild(joystick)
        
        // MARK: - Button
//        addChild(button)

        
        // MARK: - Player
        player.position = CGPoint(x: 0, y: 300)
        addChild(player)
        
        
        // MARK: - Launcher
        addChild(launcher)
        
        
        // MARK: - Camera
        scene?.addChild(sceneCamera)
        scene?.camera = sceneCamera
        sceneCamera.setScale(3)
        
        addProgressObserver()
        
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self!.dailyScene = SKScene(fileNamed: "GameScene")!
        }
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
                    button.isPressed = true
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
                    joystickData = joystick.moveStick(jsLocation: joystick.position, touchLocation: location)
                    
                    joystick.setBaseAlpha(joystickData.strength)
                    joystick.setBaseScale(joystickData.strength)
                
                    launcher.setLauncherAlpha(joystickData.strength)
                    launcher.setLauncherScale(joystickData.strength)
                    launcher.setLauncherAngle(joystickData.angle)
                    launcher.setEmitterStrength(joystickData.strength)
                }
            }
            
            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
                    // Button still being pressed
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            launcher.setLauncherAlpha(0)
            launcher.resetEmitter()

            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    joystickActive = false
                    joystick.centerStick()
                    joystick.resetBaseAlpha()
                    joystick.resetBaseScale()
                }
            }

            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
                    
                    if !button.isPressed { return }
                    
                    
                    player.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * buttonData.strength,
                                                              dy: joystickData.vector.dy * buttonData.strength))
                    
                    button.isPressed = false
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.centerStick()
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        if button.isPressed {
            buttonData.startTime = currentTime
        } else {
            buttonData.endTime = currentTime
        }
        
        
        if abs(player.position.x) > 10000 || abs(player.position.y) > 10000 {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position = CGPoint(x: 0, y: 300)
            
            run(SKAction.playSoundFileNamed("pop.m4a", waitForCompletion: false))
        }

        
        joystick.position.x = player.position.x - frame.width / 1.25
        joystick.position.y = player.position.y - frame.height / 2.5
        
        button.position.x = player.position.x + frame.width / 1.25
        button.position.y = player.position.y - frame.height / 2.5
        
        launcher.position = player.position
        sceneCamera.position = player.position
        
        cloud1.position.x = player.position.x + player.position.x * -cloud1Speed
        cloud1.position.y = player.position.y + player.position.y * -cloud1Speed
        
        skyFactory.position.x = player.position.x + player.position.x * -cloud1Speed
        skyFactory.position.y = player.position.y + player.position.y * -cloud1Speed
    }
}

// MARK: - Progress Notification Listener
extension LaunchScene {
    func updateProgressBar() {
        progressBar.run(SKAction.scaleX(to: CGFloat(progressCount / CGFloat(columns)) * progressBarMaxScale, duration: 0.2))
    }
    
    func addProgressObserver() {
        NotificationCenter.default.addObserver(forName: progressUpdate, object: nil, queue: .main) { [self] note in
            self.updateProgressBar()
            self.progressCount += 1
        }
    }
}

// MARK: - Physics Delegate

extension LaunchScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        print("contact between \(firstNode.name) and \(secondNode.name)")

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
