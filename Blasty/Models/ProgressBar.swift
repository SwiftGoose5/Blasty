//
//
//
// Created by Swift Goose on 4/19/22 AT 2:26 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class ProgressBar: SKNode {
    
    private var progressBar = SKShapeNode()
    private var progressContainer = SKShapeNode()
    private var progressPath = CGMutablePath()
    
    override init() {
        super.init()
        
        buildProgressBar()
    }
    
    private func buildProgressBar() {
        progressContainer = SKShapeNode(rectOf: CGSize(width: frame.width * 0.80, height: frame.height * 0.05), cornerRadius: 12)
        progressContainer.fillColor = .darkGray
        progressContainer.strokeColor = .darkGray
        print(progressContainer.frame.size)
        
        progressBar = SKShapeNode(rectOf: CGSize(width: frame.width * 0.40, height: frame.height * 0.04), cornerRadius: 12)
//        progressBar.position.x = 0.10 * frame.width - frame.width
        progressBar.fillColor = .orange
        progressBar.strokeColor = .orange
        progressBar.glowWidth = 4
        
        addChild(progressContainer)
        addChild(progressBar)
    }
    
    func updateProgress(_ progress: Int) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
