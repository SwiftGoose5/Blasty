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
    private let columns = 32
    private let rows = 32
    
    private var tileSize = CGSize(width: 0, height: 0)
    private var halfWidth = CGFloat(0)
    private var halfHeight = CGFloat(0)
    
    private var noiseMap = GKNoiseMap()
    
    private var tileSet = SKTileSet()
    private var bottomLayer = SKTileMapNode()
    private var topLayer = SKTileMapNode()
    
    private var waterTiles = SKTileGroup()
    private var grassTiles = SKTileGroup()
    private var sandTiles = SKTileGroup()
    private var cobbleTiles = SKTileGroup()
    
    override init() {
        super.init()
        
        noiseMap = makeNoiseMap(columns: columns, rows: rows)
        
        tileSize = CGSize(width: size, height: size)
        
        halfWidth = CGFloat(columns) / 2.0 * tileSize.width
        halfHeight = CGFloat(rows) / 2.0 * tileSize.height
        
        tileSet = SKTileSet(named: "Cobbles")!
        
        grassTiles = tileSet.tileGroups.first { $0.name == "Grass" }!
//        waterTiles = tileSet.tileGroups.first { $0.name == "Water" }!
//        sandTiles = tileSet.tileGroups.first { $0.name == "Sand" }!
//        cobbleTiles = tileSet.tileGroups.first { $0.name == "Cobblestone" }!
        
//        bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        
        topLayer.enableAutomapping = true
//        bottomLayer.fill(with: waterTiles)
        
        buildTileSet()
        buildTilePhysics()
        
        
        DispatchQueue.main.async {
            self.addChild(self.topLayer)
    //        addChild(bottomLayer)
        }
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

                if terrainHeight < -0.3 {
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                } else {
//                    topLayer.setTileGroup(sandTiles, forColumn: column, row: row)
                }
            }
        }
    }
    
    func buildTilePhysics() {
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                
                if let tileDefinition = topLayer.tileDefinition(atColumn: column, row: row) {
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
//                    print(tileTexture.description)
//                    if tileTexture.description.contains("Grass") { print("contains grass"); break }

                    let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    let tileNode = SKNode()

                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.isDynamic = false

                    tileNode.position = CGPoint(x: x, y: y)

                    addChild(tileNode)

                    tileNode.position = CGPoint(x: tileNode.position.x + position.x,
                                                y: tileNode.position.y + position.y)
                }
            }
        }
    }
}

// MARK: - Noise Map

extension MapFactory {
    func makeNoiseMap(columns: Int, rows: Int, seed: Int32 = DateFactory.dateSeed) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 1
        source.octaveCount = 5
        source.frequency = 8
        source.lacunarity = 1
        source.seed = seed
        

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
}
