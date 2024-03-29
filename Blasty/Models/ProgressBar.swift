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
    
    private var progress = CGFloat(1)
    private var progressBar = SKSpriteNode()
    private var progressContainer = SKSpriteNode()
    
    private let progressTexture = SKTexture(imageNamed: "ProgressBar")
    private let progressContainerTexture = SKTexture(imageNamed: "ProgressBarContainer")
    
    private var sceneFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override init() {
        super.init()
        
        addProgressObserver()
    }
    
    func getSceneFrame(_ sf: CGRect) {
        sceneFrame = sf
    }
    
    func buildProgressBar() {
        progressContainer = SKSpriteNode(texture: progressContainerTexture, size: progressContainerTexture.size())
        progressContainer.size.width = sceneFrame.width * 0.82 * 2
        progressContainer.size.height = sceneFrame.height * 0.18
        progressContainer.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: progressContainer.size.width, height: progressContainer.size.height))
        progressContainer.physicsBody?.affectedByGravity = false
        progressContainer.physicsBody?.isDynamic = false
        
        progressBar = SKSpriteNode(texture: progressTexture, size: progressTexture.size())
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBar.position = CGPoint(x: -(sceneFrame.width * 0.8), y: 0)
        progressBar.size.width = 0
        progressBar.size.height = sceneFrame.height * 0.12
        progressBar.zPosition = 10
        
        addChild(progressContainer)
        addChild(progressBar)
    }
    
    func updateProgressBar() {
        progressBar.run(SKAction.resize(toWidth: CGFloat(progress / CGFloat(columns)) * sceneFrame.width * 0.8 * 2.0, duration: 0.2))
    }
    
    func addProgressObserver() {
        NotificationCenter.default.addObserver(forName: progressUpdate, object: nil, queue: .main) { [weak self] note in
            guard let strongSelf = self else { return }
//            self!.updateProgressBar()
//            self!.progress += 1
            strongSelf.updateProgressBar()
            strongSelf.progress += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

