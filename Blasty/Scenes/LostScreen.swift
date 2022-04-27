//
//
//
// Created by Swift Goose on 4/27/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit


class LostScene: SKScene {
    
    var gameOver = SKLabelNode()
    var watchAd = SKLabelNode()
    
    override func didMove(to view: SKView) {
        gameOver.text = "Game Over"
        gameOver.fontName = "Helvetica Neue Bold"
        gameOver.fontSize = 150
        gameOver.fontColor = .white
        gameOver.position.y = 500
        addChild(gameOver)
        
        watchAd.text = "Watch 30 second Ad to try again?"
        watchAd.fontName = "Helvetica Neue"
        watchAd.fontSize = 150
        watchAd.fontColor = .white
        watchAd.position.y = 300
        addChild(watchAd)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if let nodeName = node.name {
                    if nodeName == "videoContinueButton" {
                        
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {

    }

}
