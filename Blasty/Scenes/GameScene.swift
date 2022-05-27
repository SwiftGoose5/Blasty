//
//
//
// Created by Swift Goose on 3/31/22 AT 11:12 AM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    let mapScale = CGFloat(3)
    
    var player = PlayerNode()
    var playerLives = PlayerLives()
    var playerCollectibles = PlayerCollectibles()

    var backgroundLabels = BackgroundLabels()
    
    var joystick = Joystick()
    var joystickActive = false
    var joystickData = JoystickData()
    
    var button = Button()
    var buttonData = ButtonData()
    
    var lastCollectibleIndex = -1
    
    var lastSpikeHitTime = Double(0)
    var lastSpikeDate = Date()
    
    var launcher = LauncherParentNode()
    
    let sceneCamera = SKCameraNode()
    
    let map = SKNode()
    let mapFactory = MapFactory()
    
    let skyFactory = SkyFactory()
    let skySpeed = CGFloat(0.6)
    
    let cloud1Texture = SKTexture(imageNamed: "Cloud1")
    
    var cloud = SKSpriteNode()
    let cloudSpeed = CGFloat(0.3)
    
    
    var startingPlatform = StartingPlatform()
    
    var launchScene = SKScene()
    var shape = SKShapeNode()
    
    var firstMove = true
    
    var timeSinceNowLabelNode = SKLabelNode()
    var startingTime = Date()
    
    override func didMove(to view: SKView) {
        name = "GameScene"
        currentScene = name!
        removeChildrenRecursively()

//        playMusic()
        
        lifeCount = 0
        collectibleCount = 0
        
        startingPlatform.buildPlatform()
        addChild(startingPlatform)
        addChild(backgroundLabels)

        backgroundColor = .purple

        // MARK: - Sky & Clouds
        addChild(skyFactory)
        
        cloud = SKSpriteNode(texture: cloud1Texture, size: cloud1Texture.size())
        cloud.setScale(20)
        cloud.zPosition = -4
        cloud.alpha = 0.2
        
        addChild(cloud)

        // MARK: - Physics Delegate
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        
        
        // MARK: - Joystick
//        joystick = Joystick()
        addChild(joystick)
        let uiPoint = CGPoint(x: -UIScreen.main.bounds.width / 2, y: -UIScreen.main.bounds.height / 2)
        let point = view.convert(uiPoint, to: self)
        
        print("points")
        print(uiPoint)
        print(point)
        
        let emp = SKShapeNode(circleOfRadius: 128)
        emp.fillColor = .black
        emp.strokeColor = .black
        emp.position = point
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height)

        print(emp.position)
        addChild(emp)
        emp.position = point
        print(emp.position)
        
        // MARK: - Button
//        button = Button()
//        addChild(button)

        // MARK: - Launcher
        launcher = LauncherParentNode()
        launcher.zPosition = -1
        
        // MARK: - Player
//        player = PlayerNode()
        player.position = CGPoint(x: 0, y: mapFactory.position.y - 5368)
        addChild(player)
        player.addChild(playerLives)
        player.addChild(playerCollectibles)
        player.addChild(launcher)
        player.addChild(timeSinceNowLabelNode)
        player.addChild(sceneCamera)
        
//        player.addChild(joystick)
//        joystick.position.x = -UIScreen.main.bounds.width * 0.75
//        joystick.position.y = -UIScreen.main.bounds.height * 0.25
        
        timeSinceNowLabelNode.position.y = screenHeight
        timeSinceNowLabelNode.fontName = "Helvetica Neue"
        timeSinceNowLabelNode.fontSize = 100
        
        // MARK: - Camera
        
        scene?.camera = sceneCamera
        sceneCamera.setScale(mapScale)
//        sceneCamera.addChild(playerLives)
//        sceneCamera.addChild(playerCollectibles)
//        sceneCamera.addChild(joystick)
        
        playerLives.setScale(1.5/mapScale)
        playerCollectibles.setScale(1.5/mapScale)
//        scene?.addChild(sceneCamera)
        
        // MARK: - Map
        addChild(mapFactory)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            
            let location = touch.location(in: self)

//            var displace = camera!.position //should be in center of screen
            
//            displace.x = displace.x - frame.size.width / 2
//            displace.y = displace.y - frame.size.height / 2
//
//            if displace.x < 0 { displace.x *= -1 }
//            if displace.y < 0 { displace.y *= -1 }
            
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x <= frame.size.width * 0.5 - displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x <= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x <= player.position.x {
                    joystickActive = true
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x >= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x >= player.position.x {
//                    buttonData.startTime = Date()
                    button.isPressed = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if player!.isMoving { return }
        
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
//            var displace = camera!.position //should be in center of screen
//            displace.x = displace.x - frame.size.width / 2
//            displace.y = displace.y - frame.size.height / 2
            
//            if location.y > frame.size.height * 0.5 + displace.y { return }
//
//            if location.x >= frame.size.width * 0.5 - displace.x { return }
            
//            joystickData = joystick!.moveStick(jsLocation: joystick!.position, touchLocation: location)
//
//            joystick?.setBaseAlpha(joystickData.strength)
//            joystick?.setBaseScale(joystickData.strength)
//
//            launcher!.setLauncherAlpha(joystickData.strength)
//            launcher!.setLauncherScale(joystickData.strength)
//            launcher!.setLauncherAngle(joystickData.angle)
//            launcher!.setEmitterStrength(joystickData.strength)
            
//            if displace.x < 0 { displace.x *= -1 }
//            if displace.y < 0 { displace.y *= -1 }
//
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x <= frame.size.width * 0.5 - displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x <= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x <= player.position.x {
                    // We're touching the left side of the screen
                    
                    // Use this for when the JS is a child by itself in the scene
                    joystickData = joystick.moveStick(jsLocation: joystick.position, touchLocation: location)
                    
                    // Use this for when the JS is a child of the player in the scene
//                    joystickData = joystick.moveStick(jsLocation: joystick.convert(joystick.position, to: self), touchLocation: location)
                    
                    joystick.setBaseAlpha(joystickData.strength)
                    joystick.setBaseScale(joystickData.strength)
                
                    launcher.setLauncherAlpha(joystickData.strength)
                    launcher.setLauncherScale(joystickData.strength)
                    launcher.setLauncherAngle(joystickData.angle)
                    launcher.setEmitterStrength(joystickData.strength)
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x >= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x >= player.position.x {
//                    print("button still being pressed")
                }
            }

                    
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            launcher.setLauncherAlpha(0)
            launcher.resetEmitter()

            
//            player?.physicsBody?.isDynamic = true
        
//            if !joystickActive { return }
            
            
//            var displace = camera!.position //should be in center of screen
//            displace.x = displace.x - frame.size.width / 2
//            displace.y = displace.y - frame.size.height / 2
            
//            if location.y > frame.size.height * 0.5 + displace.y { return }
//
//            if location.x <= frame.size.width * 0.5 + displace.x { return }
//
//            player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * -joystickData.strength,
//                                                       dy: joystickData.vector.dy * -joystickData.strength))
            
            
            // flip signs
//            if displace.x < 0 { displace.x *= -1 }
//            if displace.y < 0 { displace.y *= -1 }
            
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x <= frame.size.width * 0.5 - displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x <= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x <= player.position.x {
                    // Joystick finished moving
//                    print("joystick done moving")
                    joystickActive = false
                    joystick.centerStick()
                    joystick.resetBaseAlpha()
                    joystick.resetBaseScale()
                    joystickData = JoystickData()
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
//            if location.y < sceneCamera.position.y {
//                if location.x >= sceneCamera.position.x {
            if location.y < player.position.y {
                if location.x >= player.position.x {
//                    print("button done pressing")
                    
                    if !button.isPressed { continue }
                    
                    if firstMove {
                        firstMove = false
                    }
                    
//                    player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * -joystickData.strength * 3,
//                                                               dy: joystickData.vector.dy * -joystickData.strength * 3))
                    
                    // Reset velocity?
//                    player?.physicsBody?.velocity.dy = 0
                    
                    player.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * buttonData.strength,
                                                              dy: joystickData.vector.dy * buttonData.strength))
                    
                    button.isPressed = false
                }
            }
            
            
            
//            joystickActive = false
        }
        
//        joystickActive = false
//        joystick!.centerStick()
//        joystick!.resetBaseAlpha()
//        joystick!.resetBaseScale()
//        joystickData = JoystickData()
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
        
        if firstMove {
            startingTime = Date()
        }
        
        timeSinceNow = -startingTime.timeIntervalSinceNow
        
        secondsSinceNow = Int(timeSinceNow) % 3600 % 60
        minutesSinceNow = Int(timeSinceNow) % 3600 / 60
        
        let seconds = secondsSinceNow < 10 ? "0\(secondsSinceNow)" : String(secondsSinceNow)
        let minutes = minutesSinceNow < 10 ? "0\(minutesSinceNow)" : String(minutesSinceNow)
        
        timeSinceNowLabelNode.text = "\(minutes) : \(seconds)"
        
        
        if abs(player.position.x) > 10000 || abs(player.position.y) > 10000 {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position = CGPoint(x: 0, y: -5300)
            lifeCount += 1
            
            if lifeCount >= totalLives {
                // game over
                playerLives.updateLives()
                
                wasVictory = false
                transitionToLaunchScreen()
            } else {
                playerLives.updateLives()
            }
            
        }
        
        joystick.position.x = player.position.x - screenWidth / 1.25
        joystick.position.y = player.position.y - screenHeight / 1.6
        
        cloud.position.x = player.position.x + player.position.x * -cloudSpeed
        cloud.position.y = player.position.y + player.position.y * -cloudSpeed

        skyFactory.position.x = player.position.x + player.position.x * -skySpeed
        skyFactory.position.y = player.position.y + player.position.y * -skySpeed
        
        backgroundLabels.position.y = player.position.y + player.position.y * -skySpeed
    }
}

// MARK: - Physics Delegate

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]

        if let player = firstNode as? PlayerNode, let _ = secondNode.name?.contains("sand") {
            
            // sometimes too many collisions are detected, so we have to get the last date and time
            lastSpikeHitTime = Date().timeIntervalSince(lastSpikeDate)
            
            if lastSpikeHitTime < 1 { return }
            
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.run(SKAction.move(to: CGPoint(x: 0, y: mapFactory.position.y - 5300), duration: 0))
            
            lifeCount += 1
            
            playerLives.updateLives()
            
            if lifeCount >= totalLives {
                // game over
                transitionToLaunchScreen()
            }
            
            lastSpikeDate = Date()
        }
        
        
        if let collectible = firstNode as? Collectible {
            
            // don't hit the same collectible more than once
            if lastCollectibleIndex == collectible.index { return }
            
            collectible.collect(collectibleCount)
            collectibleCount += 1
            lastCollectibleIndex = collectible.index
            
            playerCollectibles.updateScore()
            
            if collectibleCount == totalCollectibles {
                mapFactory.addBlackHole()
                
                guard let bh = mapFactory.childNode(withName: "BlackHole") else { return }
                playerCollectibles.moveToBlackHoleLocation(bh)
            }
        }
        
        if let blackHole = firstNode as? BlackHole, let player = secondNode as? PlayerNode {
            blackHole.physicsBody?.categoryBitMask = 100
            blackHole.physicsBody?.contactTestBitMask = 100
            blackHole.physicsBody?.collisionBitMask = 100
            blackHole.field?.isEnabled = false
            player.physicsBody?.collisionBitMask = 0
            player.physicsBody?.contactTestBitMask = 0
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.run(SKAction.move(to: blackHole.position, duration: 0.2))
            
            let soundFile = "flute_victory.m4a"
            run(.playSoundFileNamed(soundFile, waitForCompletion: true))
            
            wasVictory = true
            completionTime = -startingTime.timeIntervalSinceNow
            
            let saveData = UserDefaults.standard
            saveData.set(wasVictory, forKey: "wasVictory")
            saveData.set(completionTime, forKey: "completionTime")
            saveData.set(lifeCount, forKey: "lifeCount")
            
            blackHole.run(.scale(to: 100, duration: 2))
            
            transitionToLaunchScreen()           
        }
    }
}

extension GameScene {
    func transitionToLaunchScreen() {
        isDayComplete = true
        
        let saveData = UserDefaults.standard
        saveData.set(isDayComplete, forKey: "isDayComplete")
        
        
        self.run(SKAction.sequence([.wait(forDuration: 4),
                                    .run({
                                        let transition = SKTransition.fade(withDuration: 3)
                                        let scene = SKScene(fileNamed: "LaunchScene")!
                                        scene.scaleMode = .aspectFill
                                        self.removeAllActions()
                                        self.removeChildrenRecursively()
                                        self.view?.presentScene(scene, transition: transition)
                                    })
        ])
        )
    }
}
