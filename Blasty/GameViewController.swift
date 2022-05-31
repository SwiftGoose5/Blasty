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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
        addVictoryShareObserver()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'LaunchScene.sks'
            
            if let scene = SKScene(fileNamed: "LaunchScene") {
                // Set the scale mode to scale to fit the window
                
                checkLastDateVsToday()
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
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

// MARK: - Comparing dates on app start & when app comes to foreground

extension GameViewController {
    func checkLastDateVsToday() {
        let loadData = UserDefaults.standard
        wasVictory = loadData.bool(forKey: "wasVictory")
        isDayComplete = loadData.bool(forKey: "isDayComplete")
        completionTime = loadData.double(forKey: "completionTime")
        let lastDay = loadData.object(forKey: "lastDate") as? Date
        
        if let lastDay = lastDay {
            var cal = Calendar.current
            cal.timeZone = TimeZone.current
            
            if !cal.isDateInToday(lastDay) {
                isDayComplete = false
                wasVictory = false
                loadData.set(isDayComplete, forKey: "isDayComplete")
                loadData.set(wasVictory, forKey: "wasVictory")
                loadData.set(0, forKey: "completionTime")
            }
        }
        
        loadData.set(Date(), forKey: "lastDate")
    }
    
    func addNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(appCameToForeground),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(appWentToBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @objc func appCameToForeground() {
        checkLastDateVsToday()
        
        if currentScene == "LaunchScene" && wasVictory {
            share()
        } else if currentScene == "LaunchScene" {
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "LaunchScene") {
                    // Set the scale mode to scale to fit the window
                    
                    checkLastDateVsToday()
                    
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }
    }
    
    @objc func appWentToBackground() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'LaunchScene.sks'
            
            currentScene = view.scene!.name!
            print("view current scene name: \(currentScene)")
        }
    }
}

extension UIViewController {
    func share() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        
        completionTime = UserDefaults.standard.double(forKey: "completionTime")
        
        completionSeconds = Int(completionTime) % 60
        completionMinutes = Int(completionTime) % 3600 / 60
        
        let seconds = completionSeconds < 10 ? "0\(completionSeconds)" : String(completionSeconds)
        let minutes = completionMinutes < 10 ? "0\(completionMinutes)" : String(completionMinutes)
        
        let balls = String(repeating: "🎾", count: totalLives - UserDefaults.standard.integer(forKey: "lifeCount"))
        
        let items = ["Blasty: \(dateFormatter.string(from: date))\n\(minutes):\(seconds): \(balls)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(ac, animated: true)
    }
}

// MARK: - Adding Notification Observer to listen for victory and share
extension GameViewController {
    func addVictoryShareObserver() {
        NotificationCenter.default.addObserver(forName: victoryToShare, object: nil, queue: .main) { [weak self] note in
            guard let strongSelf = self else { return }
            strongSelf.share()
        }
    }
}
