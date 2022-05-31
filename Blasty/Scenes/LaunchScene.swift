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
import AVFoundation


class LaunchScene: SKScene {
    var player = PlayerNode()
    
    var startingPlatform = StartingPlatform()
    
    var portal = BlackHole()

    var joystick = Joystick()
    var joystickData = JoystickData()
    var joystickActive = false
    
    var button = Button()
    var buttonData = ButtonData()
    
    var launcher = LauncherParentNode()
    
    let sceneCamera = SKCameraNode()
    
    let skyFactory = SkyFactory()
    let skySpeed = CGFloat(0.6)
    
    var cloud = SKSpriteNode()
    let cloudSpeed = CGFloat(0.3)
    let cloudTexture = SKTexture(imageNamed: "Cloud1")
    
    var dailyScene = SKScene()
    
    var progressCount = 1
    let progressBar = ProgressBar()
    
    var nextDayLabelNode = SKLabelNode()
    
    override func willMove(from view: SKView) {
        removeAllActions()
        removeChildrenRecursively()
        skyFactory.teardown()
    }
    
    override func didMove(to view: SKView) {
        name = "LaunchScene"
        currentScene = name!
        removeChildrenRecursively()
        
        SKTextureAtlas(named: "Grid Tile Sprite Atlas").preload {
            
        }
        run(.sequence([.wait(forDuration: 0.5),
                       .playSoundFileNamed("flute_g.m4a", waitForCompletion: false), .wait(forDuration: 0.27),
                       .playSoundFileNamed("flute_b.m4a", waitForCompletion: false), .wait(forDuration: 0.27),
                       .playSoundFileNamed("flute_d.m4a", waitForCompletion: false), .wait(forDuration: 0.27)
        ]))
        
        
        collectibleSet = CollectibleSet()
        
        lifeCount = 0
        collectibleCount = 0
        
        let loadData = UserDefaults.standard
        loadData.set(false, forKey: "wasVictory")
        loadData.set(false, forKey: "isDayComplete")
        
        wasVictory = loadData.bool(forKey: "wasVictory")
        isDayComplete = loadData.bool(forKey: "isDayComplete")
        
        if !isDayComplete {
            addProgressObserver()
            loadData.set(lifeCount, forKey: "lifeCount")
            DispatchQueue.global(qos: .default).async {
                self.dailyScene = SKScene(fileNamed: "GameScene")!
                self.dailyScene.scaleMode = .aspectFill
            }
        }
        
        if wasVictory {
            run(.sequence([.wait(forDuration: 3),
                           .run {
                               NotificationCenter.default.post(name: victoryToShare, object: nil)
                           }]))
        }


        nextDayLabelNode.fontName = "Helvetica Neue Bold"
        nextDayLabelNode.fontSize = 150
        nextDayLabelNode.position.y = 400
        addChild(nextDayLabelNode)
        
        nextDayLabelNode.isHidden = !isDayComplete

        
        // MARK: - Progress Bar

        progressBar.getSceneFrame(frame)
        progressBar.buildProgressBar()
        addChild(progressBar)
        
        // MARK: - Cloud
        cloud = SKSpriteNode(texture: cloudTexture, size: cloudTexture.size())
        cloud.setScale(20)
        cloud.zPosition = -4
        cloud.alpha = 0.2
        
        startingPlatform.buildPlatform(isStart: true)
        addChild(startingPlatform)
        
        addChild(skyFactory)
        addChild(cloud)

        // MARK: - Physics Delegate
        scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        backgroundColor = .blue
        
        addChild(joystick)
        
        
        // MARK: - Player
        player.position = CGPoint(x: 0, y: 310)
        addChild(player)
        launcher.zPosition = -1
        player.addChild(launcher)
        
        // MARK: - Camera
        scene?.addChild(sceneCamera)
        scene?.camera = sceneCamera
        sceneCamera.setScale(3)
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
                    joystickData = JoystickData()
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
            player.position = CGPoint(x: 0, y: 310)
            
            run(SKAction.playSoundFileNamed("pop.m4a", waitForCompletion: false))
        }

        if UIDevice.current.userInterfaceIdiom == .phone {
            joystick.position.x = player.position.x - screenWidth / 0.75
            joystick.position.y = player.position.y - screenHeight / 1.5

        } else if UIDevice.current.userInterfaceIdiom == .pad {
            joystick.position.x = player.position.x - screenWidth / 1.25
            joystick.position.y = player.position.y - screenHeight / 1.4
        }
        
        sceneCamera.position = player.position
        
        cloud.position.x = player.position.x + player.position.x * -cloudSpeed
        cloud.position.y = player.position.y + player.position.y * -cloudSpeed
        
        skyFactory.position.x = player.position.x + player.position.x * -skySpeed
        skyFactory.position.y = player.position.y + player.position.y * -skySpeed
        
        timeUntilMidnight = Date().numberOfSecondsUntilMidnight!
        
        secondsUntilMidnight = Int(timeUntilMidnight) % 60
        minutesUntilMidnight = Int(timeUntilMidnight) % 3600 / 60
        hoursUntilMidnight   = Int(timeUntilMidnight) / 3600
        
        let seconds = secondsUntilMidnight < 10 ? "0\(secondsUntilMidnight)" : String(secondsUntilMidnight)
        let minutes = minutesUntilMidnight < 10 ? "0\(minutesUntilMidnight)" : String(minutesUntilMidnight)
        let hours   = hoursUntilMidnight   < 10 ? "0\(hoursUntilMidnight)"   : String(hoursUntilMidnight)
        
        nextDayLabelNode.text = "\(hours) : \(minutes) : \(seconds)"
    }
}


// MARK: - Progress Notification Listener
extension LaunchScene {
    func addProgressObserver() {
        NotificationCenter.default.addObserver(forName: progressUpdate, object: nil, queue: .main) { [weak self] note in
            
            guard let strongSelf = self else { return }
            
            strongSelf.progressCount += 1
            
            if strongSelf.progressCount <= columns { return }
            
            strongSelf.portal.setScale(0)
            strongSelf.portal.removeFromParent()
            strongSelf.addChild(strongSelf.portal)
            strongSelf.portal.run(SKAction.scale(to: 100, duration: 1.5))
            
            strongSelf.run(.sequence([.wait(forDuration: 2),
                                      .run({
                                          let transition = SKTransition.fade(withDuration: 0.5)
                                          strongSelf.dailyScene.scaleMode = .aspectFill
                                          strongSelf.removeAllActions()
                                          strongSelf.removeChildrenRecursively()
                                          NotificationCenter.default.removeObserver(strongSelf)
                                          strongSelf.view?.presentScene(strongSelf.dailyScene, transition: transition)
                                      })
            ])
            )
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
//
//extension LaunchScene {
//    func playMusic() {
//        if let musicURL = Bundle.main.url(forResource: "bg_music_intro", withExtension: "m4a") {
//            if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
//                music = audioPlayer
//                music.numberOfLoops = -1
//                music.volume = 0.2
//                music.play()
//            }
//        }
//    }
//
//    func stopMusic() {
//        music.stop()
//    }
//}
