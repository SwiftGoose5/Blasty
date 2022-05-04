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


class GameScene: SKScene {
    let mapScale = CGFloat(3)
    
    
    var player = PlayerNode()
    var playerLives = PlayerLives()
    var playerCollectibles = PlayerCollectibles()
    
    var ground: TerrainNode?
    var ceiling: TerrainNode?
    
    var backgroundLabels = BackgroundLabels()
    
    var wall: TerrainNode?
    var wall2: TerrainNode?
    
    var joystick = Joystick()
    var joystickActive = false
    var joystickData = JoystickData()
    
    var button = Button()
    var buttonData = ButtonData()
    
    var lastCollectibleIndex = -1
//    var score = Score()
    
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
        
        SKTextureAtlas(named: "Grid Tile Sprite Atlas").preload {
            
        }
        
        launchScene = SKScene(fileNamed: "LaunchScene")!
        
        
//        playerLives.setScale(1.25)
        playerLives.alpha = 0.8
//        playerCollectibles.setScale(1.25)
        playerCollectibles.alpha = 0.8
//        addChild(playerLives)
//        addChild(playerCollectibles)
        
        startingPlatform.buildPlatform()
        addChild(startingPlatform)
        
//        score.zPosition = 10
//        addChild(score)
        
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
        joystick = Joystick()
        addChild(joystick)
        
        // MARK: - Button
        button = Button()
//        addChild(button)

        // MARK: - Launcher
        launcher = LauncherParentNode()
        launcher.zPosition = -1
        
        // MARK: - Player
        player = PlayerNode()
        player.position = CGPoint(x: 0, y: mapFactory.position.y - 5368)
        addChild(player)
        player.addChild(playerLives)
        player.addChild(playerCollectibles)
        player.addChild(launcher)
        player.addChild(timeSinceNowLabelNode)
        player.addChild(sceneCamera)
        
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
        
        
        // Ground
        ground = TerrainNode(size: CGSize(width: (scene?.frame.width)! * 20, height: 30), pos: CGPoint(x: 0, y: -450), rot: 0)
//        self.addChild(ground!)
        
        ceiling = TerrainNode(size: CGSize(width: (scene?.frame.width)! * 10, height: 60), pos: CGPoint(x: 0, y: 550), rot: 1)
//        self.addChild(ceiling!)
        
        
        // Wall
        wall = TerrainNode(size: CGSize(width: (scene?.frame.width)!, height: 60), pos: CGPoint(x: 40, y: -250), rot: 0.5)
        wall?.name = "wall"
//        self.addChild(wall!)
        
        
//        // Breaker check
//        wall2 = TerrainNode(size: CGSize(width: 600, height: 120), pos: CGPoint(x: -400, y: -250), rot: 0.75)
//        wall2?.name = "wall2"
//        wall2?.physicsBody?.isDynamic = true
//        wall2?.physicsBody?.affectedByGravity = false
//        wall2?.physicsBody?.mass = 0.5
//        self.addChild(wall2!)
        
        // MARK: - Map
        addChild(mapFactory)

//        playerLives.position.x = (screenWidth * mapScale / 2 - playerLives.width) / 2
//        playerLives.position.x = screenWidth / 2
//        playerLives.position.y = screenHeight/2 - (screenHeight * mapScale / 10 - playerLives.height) / 2
//        playerLives.position.y = screenHeight/2
        
//        playerCollectibles.position.x = -screenWidth / 2 + (screenWidth * mapScale / 2 - playerCollectibles.width) / 2
//        playerCollectibles.position.x = -screenWidth / 2
//        playerCollectibles.position.y = screenHeight/2 - (screenHeight * mapScale / 10 - playerCollectibles.height) / 2
//        playerCollectibles.position.y = screenHeight/2
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
                    joystickData = joystick.moveStick(jsLocation: joystick.position, touchLocation: location)
                    
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
//                    joystickData = JoystickData()
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
            
        

//        let playerVector = player?.physicsBody?.velocity
//        
//        if abs(playerVector!.dx.rounded()) >= 10.0 || abs(playerVector!.dy.rounded()) >= 10.0 {
//            player?.isMoving = true
//            joystick!.alpha = 0.3
//        } else {
//            player?.isMoving = false
//            joystick!.alpha = 1
//        }
        
        
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
        
        button.position.x = player.position.x + screenWidth / 1.25
        button.position.y = player.position.y - screenHeight / 1.6
        
//        launcher.position = player.position
//        sceneCamera.position = player.position
        
        cloud.position.x = player.position.x + player.position.x * -cloudSpeed
        cloud.position.y = player.position.y + player.position.y * -cloudSpeed

        skyFactory.position.x = player.position.x + player.position.x * -skySpeed
        skyFactory.position.y = player.position.y + player.position.y * -skySpeed
        
        backgroundLabels.position.y = player.position.y + player.position.y * -skySpeed
        
//        playerLives.position.x = player.position.x + screenWidth / 3
//        playerLives.position.x = player.position.x + (screenWidth * mapScale / 2 - playerLives.width) / 2
        
        
//        playerCollectibles.position.x = player.position.x - screenWidth / 2 * mapScale + (screenWidth / 2 * mapScale - playerCollectibles.width) / 2
//        playerCollectibles.position.x = player.position.x + (screenWidth * mapScale / 2 - playerLives.width) / 2
        
//        playerCollectibles.position.x = player.position.x + screenWidth / 3
        
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
        
        
//        if secondNode.name == "wall", let player = firstNode as? PlayerNode {
//            player.physicsBody?.isDynamic = false
//        }
//
//        if secondNode.name == "wall2", let player = firstNode as? PlayerNode {
//            secondNode.physicsBody?.affectedByGravity = true
//        }
        
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
            
//            score.updateScore()
            playerCollectibles.updateScore()
            
            if collectibleCount == totalCollectibles {
                mapFactory.buildBlackHole()
                
                guard let bh = mapFactory.childNode(withName: "BlackHole") else { return }
                playerCollectibles.moveToBlackHoleLocation(bh)
            }
        }
        
        if let blackHole = firstNode as? BlackHole, let player = secondNode as? PlayerNode {
            blackHole.field?.isEnabled = false
            player.physicsBody?.collisionBitMask = 0
            player.physicsBody?.contactTestBitMask = 0
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.run(SKAction.move(to: blackHole.position, duration: 0.2))
            
            wasVictory = true
            completionTime = -startingTime.timeIntervalSinceNow
            
            transitionToLaunchScreen()
        }
    }
}

extension GameScene {
    func transitionToLaunchScreen() {
        isDayComplete = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let transition = SKTransition.fade(withDuration: 2)
            self.launchScene.scaleMode = .aspectFill
            self.view?.presentScene(self.launchScene, transition: transition)
        }
    }
}
