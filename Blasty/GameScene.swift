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

enum CollisionType: UInt32 {
    case player = 1
    case ground = 2
    case spikes = 4
    case victory = 8
    case field = 16
    case collectible = 32
}

class GameScene: SKScene {
    var player: PlayerNode?
    var ground: TerrainNode?
    var ceiling: TerrainNode?
    
    var wall: TerrainNode?
    var wall2: TerrainNode?
    
    var startTouch : CGPoint?
    var endTouch : CGPoint?
    
    var joystick : Joystick?
    var joystickActive = false
    var joystickData = JoystickData()
    
    var button : Button?
    var buttonData = ButtonData()
    
    
    var launcher: LauncherParentNode?
    
    let sceneCamera = SKCameraNode()
    
    let map = SKNode()
    let mapFactory = MapFactory()
    
    let skyFactory = SkyFactory()
    var cloud1 = SKSpriteNode()
    var cloud2 = SKSpriteNode()
    var cloud3 = SKSpriteNode()
    let cloud1Speed = CGFloat(0.3)
    let cloud2Speed = CGFloat(0.4)
    let cloud3Speed = CGFloat(0.6)
    
    var startingPlatform = StartingPlatform()
    
    override func didMove(to view: SKView) {
        
        SKTextureAtlas(named: "Grid Tile Sprite Atlas").preload {
            
        }
        
        addChild(startingPlatform)
        

        backgroundColor = .purple

        // MARK: - Sky & Clouds
        addChild(skyFactory)
        
        let cloud1Texture = SKTexture(imageNamed: "Cloud1")
        cloud1 = SKSpriteNode(texture: cloud1Texture, size: cloud1Texture.size())
        cloud1.setScale(20)
        cloud1.zPosition = -4
        cloud1.alpha = 0.2
        
        
        let cloud2Texture = SKTexture(imageNamed: "Cloud2")
        cloud2 = SKSpriteNode(texture: cloud2Texture, size: cloud2Texture.size())
        cloud2.setScale(15)
        cloud2.zPosition = -3
        cloud2.alpha = 0.4
        
        
        let cloud3Texture = SKTexture(imageNamed: "Cloud3")
        cloud3 = SKSpriteNode(texture: cloud3Texture, size: cloud3Texture.size())
        cloud3.setScale(10)
        cloud3.zPosition = -2
        cloud3.alpha = 0.2
//        addChild(cloud1)
//        addChild(cloud2)
//        addChild(cloud3)
        
        
        
        
        
        
        
        // MARK: - Physics Delegate
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        
        
        // MARK: - Joystick
        joystick = Joystick()
        addChild(joystick!)
        
        // MARK: - Button
        button = Button()
        addChild(button!)

        
        // MARK: - Player
        player = PlayerNode()
        player!.position = CGPoint(x: 0, y: -5368)
        addChild(player!)
        startTouch = CGPoint(x: 0, y: 0)
        endTouch = CGPoint(x: 0, y: 0)
        
        
        // MARK: - Launcher
        launcher = LauncherParentNode()
        addChild(launcher!)
        
        
        // MARK: - Camera
        scene?.addChild(sceneCamera)
        scene?.camera = sceneCamera
        sceneCamera.setScale(3)
        
        
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
//        addChild(frameFactory)
        
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
            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    joystickActive = true
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
//                    buttonData.startTime = Date()
                    button!.isPressed = true
                }
            }
            
            startTouch = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if player!.isMoving { return }
        joystickActive = true
        
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
            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    // We're touching the right side of the screen
                    joystickData = joystick!.moveStick(jsLocation: joystick!.position, touchLocation: location)
                    
                    joystick?.setBaseAlpha(joystickData.strength)
                    joystick?.setBaseScale(joystickData.strength)
                    
                    launcher!.setLauncherAlpha(joystickData.strength)
                    launcher!.setLauncherScale(joystickData.strength)
                    launcher!.setLauncherAngle(joystickData.angle)
                    launcher!.setEmitterStrength(joystickData.strength)
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
//                    print("button still being pressed")
                }
            }

                    
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            launcher?.setLauncherAlpha(0)
            launcher?.resetEmitter()

            
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
            if location.y < sceneCamera.position.y {
                if location.x <= sceneCamera.position.x {
                    // Joystick finished moving
//                    print("joystick done moving")
                    joystickActive = false
                    joystick!.centerStick()
                    joystick!.resetBaseAlpha()
                    joystick!.resetBaseScale()
//                    joystickData = JoystickData()
                }
            }
            
//            if location.y < frame.size.height * 0.5 - displace.y {
//                if location.x >= frame.size.width * 0.5 + displace.x {
            if location.y < sceneCamera.position.y {
                if location.x >= sceneCamera.position.x {
//                    print("button done pressing")
                    
                    button!.isPressed = false
                    
//                    player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * -joystickData.strength * 3,
//                                                               dy: joystickData.vector.dy * -joystickData.strength * 3))
                    
                    // Reset velocity?
//                    player?.physicsBody?.velocity.dy = 0
                    
                    player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * buttonData.strength,
                                                               dy: joystickData.vector.dy * buttonData.strength))
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
        joystick!.centerStick()
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        
        if button!.isPressed {
            buttonData.startTime = currentTime
        } else {
            buttonData.endTime = currentTime
        }

//        let playerVector = player?.physicsBody?.velocity
//        
//        if abs(playerVector!.dx.rounded()) >= 10.0 || abs(playerVector!.dy.rounded()) >= 10.0 {
//            player?.isMoving = true
//            joystick!.alpha = 0.3
//        } else {
//            player?.isMoving = false
//            joystick!.alpha = 1
//        }
        
        
        if abs(player!.position.x) > 10000 || abs(player!.position.y) > 10000 {
            player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player?.position = CGPoint(x: 0, y: -5300)
        }
        
//        if playerVector!.dx >= 100 {
//            player?.physicsBody?.velocity.dx = 100
//        }
//
//        if playerVector!.dx <= -100 {
//            player?.physicsBody?.velocity.dx = -100
//        }
//        
//        if playerVector!.dy > 100 {
//            player?.physicsBody?.velocity.dy = 100
//        }
//
//        if playerVector!.dy <= -100 {
//            player?.physicsBody?.velocity.dy = -100
//        }
        
        joystick?.position.x = player!.position.x - frame.width / 1.25
        joystick?.position.y = player!.position.y - frame.height / 2.5
        
        button?.position.x = player!.position.x + frame.width / 1.25
        button?.position.y = player!.position.y - frame.height / 2.5
        
        launcher?.position = player!.position
        sceneCamera.position = player!.position
        
        cloud1.position.x = player!.position.x + player!.position.x * -cloud1Speed
        cloud2.position.x = player!.position.x + player!.position.x * -cloud2Speed
        cloud3.position.x = player!.position.x + player!.position.x * -cloud3Speed
        skyFactory.position.x = player!.position.x + player!.position.x * -cloud3Speed
        
        cloud1.position.y = player!.position.y + player!.position.y * -cloud1Speed
        cloud2.position.y = player!.position.y + player!.position.y * -cloud2Speed
        cloud3.position.y = player!.position.y + player!.position.y * -cloud3Speed
        skyFactory.position.y = player!.position.y + player!.position.y * -cloud3Speed
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
        
        print("contact between \(firstNode.name) and \(secondNode.name)")
        
//        if secondNode.name == "wall", let player = firstNode as? PlayerNode {
//            player.physicsBody?.isDynamic = false
//        }
//
//        if secondNode.name == "wall2", let player = firstNode as? PlayerNode {
//            secondNode.physicsBody?.affectedByGravity = true
//        }
        
//        if let player = firstNode as? PlayerNode, secondNode.name == "spikes" {
//            // dead
//            player.run(SKAction.scale(to: 0, duration: 0.75))
//        }
        
        if let collectible = firstNode as? Collectible {
            
            collectible.collect(collectibleCount)
            collectible.physicsBody?.contactTestBitMask = 0
            collectible.physicsBody?.categoryBitMask = 0
            
            collectibleCount += 1
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
