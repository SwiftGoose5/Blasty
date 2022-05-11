//
//
//
// Created by Swift Goose on 3/31/22 AT 11:12 AM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var previousScene = SKScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "LaunchScene") {
                // Set the scale mode to scale to fit the window
                
                let loadData = UserDefaults.standard
                wasVictory = loadData.bool(forKey: "wasVictory")
                isDayComplete = loadData.bool(forKey: "isDayComplete")
                let lastDay = loadData.object(forKey: "lastDate") as? Date
                
                if let lastDay = lastDay {
                    var cal = Calendar.current
                    cal.timeZone = TimeZone.current
                    
                    if !cal.isDateInToday(lastDay) {
                        isDayComplete = false
                        loadData.set(isDayComplete, forKey: "isDayComplete")
                    }
                }
                
                loadData.set(Date(), forKey: "lastDate")
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                previousScene = scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
