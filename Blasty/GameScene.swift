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
    case enemy = 4
    case enemySpell = 8
}

class GameScene: SKScene {
    
    var joystickData = JoystickData()
    
    private var sky: SKSpriteNode?
    
    private var player: PlayerNode?
    private var ground: TerrainNode?
    private var ceiling: TerrainNode?
    
    private var wall: TerrainNode?
    private var wall2: TerrainNode?
    
    private var startTouch : CGPoint?
    private var endTouch : CGPoint?
    
    private var joystick : Joystick?
    private var joystickActive = false
    
    private var launcher: LauncherParentNode?
    
    private var lastPlayerVector: CGVector?
    
    let sceneCamera = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        
        scene?.scaleMode = .aspectFit
        isUserInteractionEnabled = true
        
        
        // MARK: - Sky
        sky = SKSpriteNode(imageNamed: "Sky")
        sky?.scale(to: CGSize(width: 128000, height: 72000))
        sky?.zPosition = -10
        addChild(sky!)
        
        
        // MARK: - Physics Delegate
        physicsWorld.contactDelegate = self
        
        
        // MARK: - Joystick
        joystick = Joystick()
        addChild(joystick!)

        
        // MARK: - Player
        player = PlayerNode()
        addChild(player!)
        lastPlayerVector = CGVector(dx: 0, dy: 0)
        startTouch = CGPoint(x: 0, y: 0)
        endTouch = CGPoint(x: 0, y: 0)
        
        
        // MARK: - Launcher
        launcher = LauncherParentNode()
        addChild(launcher!)
        
        
        // MARK: - Camera
        scene?.addChild(sceneCamera)
        scene?.camera = sceneCamera
        scene?.camera?.setScale(1.5)
        
        
        // Ground
        ground = TerrainNode(size: CGSize(width: (scene?.frame.width)! * 20, height: 300), pos: CGPoint(x: 0, y: -250), rot: 0)
        self.addChild(ground!)
        
        ceiling = TerrainNode(size: CGSize(width: (scene?.frame.width)! * 10, height: 60), pos: CGPoint(x: 0, y: 550), rot: 1)
        self.addChild(ceiling!)
        
        
        // Wall
        wall = TerrainNode(size: CGSize(width: (scene?.frame.width)!, height: 60), pos: CGPoint(x: 40, y: -250), rot: 0.5)
        wall?.name = "wall"
        self.addChild(wall!)
        
        
//        // Breaker check
//        wall2 = TerrainNode(size: CGSize(width: 600, height: 120), pos: CGPoint(x: -400, y: -250), rot: 0.75)
//        wall2?.name = "wall2"
//        wall2?.physicsBody?.isDynamic = true
//        wall2?.physicsBody?.affectedByGravity = false
//        wall2?.physicsBody?.mass = 0.5
//        self.addChild(wall2!)
        
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            startTouch = touch.location(in: self)
            joystickActive = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        joystickActive = true
        
        if !player!.isMoving {
            for touch in touches {
                
                let location = touch.location(in: self)
                
                var displace = camera!.position //should be in center of screen
                displace.x = displace.x - frame.size.width / 2
                displace.y = displace.y - frame.size.height / 2
                
                if location.y < frame.size.height * 0.5 + displace.y {
                    if location.x >= frame.size.width * 0.5 + displace.x {
                        // RHS
                        joystickData = joystick!.moveStick(jsLocation: joystick!.position, touchLocation: location)
                        
                        joystick?.setBaseAlpha(joystickData.strength)
                        joystick?.setBaseScale(joystickData.strength)
                        
                        launcher!.setLauncherAlpha(joystickData.strength)
                        launcher!.setLauncherScale(joystickData.strength)
                        launcher!.setLauncherAngle(joystickData.angle)
                        launcher!.setEmitterStrength(joystickData.strength)
                        
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            launcher?.setLauncherAlpha(0)
            launcher?.resetEmitter()

            
            player?.physicsBody?.isDynamic = true
//            player?.physicsBody?.applyImpulse(CGVector(dx: (startTouch!.x - location.x) * joystickData.strength,
//                                                       dy: (startTouch!.y - location.y) * joystickData.strength))
            
            player?.physicsBody?.applyImpulse(CGVector(dx: joystickData.vector.dx * -joystickData.strength,
                                                       dy: joystickData.vector.dy * -joystickData.strength))

            
            
        }
        
        joystickActive = false
        joystick!.centerStick()
        joystick!.resetBaseAlpha()
        joystick!.resetBaseScale()
        joystickData = JoystickData()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick!.centerStick()
        
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {

        let playerVector = player?.physicsBody?.velocity
        print(abs(playerVector!.dx.rounded()))
        
        if abs(playerVector!.dx.rounded()) >= 10.0 || abs(playerVector!.dy.rounded()) >= 10.0 {
            player?.isMoving = true
            joystick!.alpha = 0.3
        } else {
            player?.isMoving = false
            joystick!.alpha = 1
        }
        
        
//        if abs(playerVector!.dx) > abs(lastPlayerVector!.dx) {
//            let xVel = abs(playerVector!.dx)
//            print("xvel: \(xVel)")
//            camera?.run(SKAction.scale(to: xVel / 400, duration: 0.8))
//        }
//
//        if abs(playerVector!.dy) > abs(lastPlayerVector!.dy) {
//            let yVel = abs(playerVector!.dy)
//            print("yvel: \(yVel)")
//            camera?.run(SKAction.scale(to: yVel / 400, duration: 0.8))
//        }
//
//        if abs(playerVector!.dx) <= 30 && abs(playerVector!.dy) <= 30 {
//            camera?.run(SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.8))
//        }
        
//        camera?.run(SKAction.move(to: player!.position, duration: 0))
        

        
//        if !jsActive {
//            js?.position.x = player!.position.x + frame.width / 3
//            js?.position.y = player!.position.y - frame.height / 6
//        }
        
        joystick?.position.x = player!.position.x + frame.width / 3
        joystick?.position.y = player!.position.y - frame.height / 6
        launcher?.position = player!.position
        camera!.position = player!.position
        
        lastPlayerVector = playerVector
        
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
        
//        print("contact between \(firstNode.name) and \(secondNode.name)")
        
        if secondNode.name == "wall", let player = firstNode as? PlayerNode {
            player.physicsBody?.isDynamic = false
        }
        
        if secondNode.name == "wall2", let player = firstNode as? PlayerNode {
            secondNode.physicsBody?.affectedByGravity = true
        }
    }
}
