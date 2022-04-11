//
//
//
// Created by Swift Goose on 4/5/22 AT 8:19 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//

import SpriteKit
import GameplayKit

class MapFactory: SKNode {

    private let size = 128
    private let columns = 64
    private let rows = 64

    private var tileSize = CGSize(width: 0, height: 0)
    private var halfWidth = CGFloat(0)
    private var halfHeight = CGFloat(0)
    
    private var noiseMap = GKNoiseMap()
    
    private var tileSet = SKTileSet()
    private var bottomLayer = SKTileMapNode()
    private var topLayer = SKTileMapNode()
    
    private var waterTiles = SKTileGroup()
    private var sandyCobble = SKTileGroup()
    private var cobblySand = SKTileGroup()
    private var grassyWater = SKTileGroup()
    private var cobbleTiles = SKTileGroup()
    private var grassTiles = SKTileGroup()
    
    override init() {
        super.init()
        
        noiseMap = makeNoiseMap(columns: columns, rows: rows)
        
        tileSize = CGSize(width: size, height: size)
        
        halfWidth = CGFloat(columns) / 2.0 * tileSize.width
        halfHeight = CGFloat(rows) / 2.0 * tileSize.height
        
        tileSet = SKTileSet(named: "StockTile")!
        
        sandyCobble = tileSet.tileGroups.first { $0.name == "SandyCobble" }!
        cobblySand = tileSet.tileGroups.first { $0.name == "CobblySand" }!
        grassyWater = tileSet.tileGroups.first { $0.name == "GrassyWater" }!
        grassTiles = tileSet.tileGroups.first { $0.name == "Grass" }!
        cobbleTiles = tileSet.tileGroups.first { $0.name == "Cobblestone" }!
//        waterTiles = tileSet.tileGroups.first { $0.name == "Water" }!
        
//        bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        topLayer.enableAutomapping = true
//        bottomLayer.fill(with: waterTiles)
        
        buildTileSet()
        buildTilePhysics()
        addChild(topLayer)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapFactory {
    func buildTileSet() {
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                
                let location = vector2(Int32(row), Int32(column))
                let terrainHeight = noiseMap.value(at: location)

                if terrainHeight < -0.7 {
                    topLayer.setTileGroup(sandyCobble, forColumn: column, row: row)
                } else if terrainHeight > 0.98 {
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }
    }
    
    func buildTilePhysics() {
        let blackHolePoint = RNGFactory.colRow
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                
                if column == blackHolePoint[0] && row == blackHolePoint[1] {
                    print("spawning BH at cr: \(blackHolePoint)")
                    
                    let blackHole = BlackHole()

                    let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)

                    blackHole.position = CGPoint(x: x, y: y)

                    addChild(blackHole)

                    blackHole.position = CGPoint(x: blackHole.position.x + position.x,
                                                y: blackHole.position.y + position.y)
                }
                
                guard let tileDefinition = topLayer.tileDefinition(atColumn: column, row: row) else { continue }
                
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                
                if tileTexture.description.contains("Center") { continue }
                
                let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                let tileNode = SKNode()

                tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                
                if tileTexture.description.contains("Grass") {
                    tileNode.name = "spikes"
                    tileNode.physicsBody?.categoryBitMask = CollisionType.spikes.rawValue
                    tileNode.physicsBody?.collisionBitMask = CollisionType.player.rawValue
                    tileNode.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
                }

                tileNode.position = CGPoint(x: x, y: y)

                addChild(tileNode)

                tileNode.position = CGPoint(x: tileNode.position.x + position.x,
                                            y: tileNode.position.y + position.y)
                
                
                
                
                
//                if let tileDefinition = topLayer.tileDefinition(atColumn: column, row: row) {
//                    let tileArray = tileDefinition.textures
//                    let tileTexture = tileArray[0]
//
//
//
//                    if !tileTexture.description.contains("Center") {
//                        let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
//                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
//                        let tileNode = SKNode()
//
//                        tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
//                        tileNode.physicsBody?.affectedByGravity = false
//                        tileNode.physicsBody?.isDynamic = false
//
//                        // Check for grass aka spike texture
//                        if tileTexture.description.contains("Grass") {
//                            tileNode.name = "spikes"
//                            tileNode.physicsBody?.categoryBitMask = CollisionType.spikes.rawValue
//                            tileNode.physicsBody?.collisionBitMask = CollisionType.player.rawValue
//                            tileNode.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
//                        }
//
//                        tileNode.position = CGPoint(x: x, y: y)
//
//                        addChild(tileNode)
//
//                        tileNode.position = CGPoint(x: tileNode.position.x + position.x,
//                                                    y: tileNode.position.y + position.y)
//                    }
//                }
                
                
            }
        }
    }
}

// MARK: - Noise Map

extension MapFactory {
    func makeNoiseMap(columns: Int, rows: Int, seed: Int32 = DateFactory.dateSeed) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 1
        source.octaveCount = 2
        source.frequency = 120
        source.lacunarity = 1
        source.seed = seed
        

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
}
