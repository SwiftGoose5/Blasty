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

    let debug = false
    private let size = 128
    private var tileSize = CGSize(width: 0, height: 0)
    private var halfWidth = CGFloat(0)
    private var halfHeight = CGFloat(0)
    
    private var noiseMap = GKNoiseMap()
    
    private var tileSet = SKTileSet()
    private var bottomLayer = SKTileMapNode()
    private var topLayer = SKTileMapNode()
    
    private var cobbleTiles = SKTileGroup()
    private var sandTiles = SKTileGroup()
    
    private var blackHole = BlackHole()
    
    private var availableCoordinates = [[Int]]()
    
    override init() {
        super.init()
        
        removeChildrenRecursively()
        
        
        noiseMap = makeNoiseMap(columns: columns, rows: rows)
        
        tileSize = CGSize(width: size, height: size)
        
        halfWidth = CGFloat(columns) / 2.0 * tileSize.width
        halfHeight = CGFloat(rows) / 2.0 * tileSize.height
        
        tileSet = SKTileSet(named: "StockTile")!
        
        cobbleTiles = tileSet.tileGroups.first { $0.name == "Cobblestone" }!
        sandTiles   = tileSet.tileGroups.first { $0.name == "Sand" }!
        
//        bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        topLayer.enableAutomapping = true
//        bottomLayer.fill(with: waterTiles)
        
        buildMap()
    }
    
    func buildMap(isStartingMap: Bool = false) {
        
        buildTileSet()
        buildTilePhysics()
        buildCollectibles()
        buildBlackHole()
        
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

                if terrainHeight < -0.89 {
                    topLayer.setTileGroup(cobbleTiles, forColumn: column, row: row)
                } else if terrainHeight > 0.99 {
                    topLayer.setTileGroup(sandTiles, forColumn: column, row: row)
                }
//                else {
//                    availableCoordinates.append([column, row])
//                }
            }
        }
    }
    
    func buildTilePhysics() {
        for column in 0 ..< columns {
            
            for row in 0 ..< rows {
                
                guard let tileDefinition = topLayer.tileDefinition(atColumn: column, row: row) else { continue }
                
                
                let tileArray = tileDefinition.textures
                let tileTexture = tileArray[0]
                
                
                // MARK: - Skip Center tiles so that collectibles can't spawn inside inaccessible areas
                if tileTexture.description.contains("Center") { continue }
                
                availableCoordinates.append([column, row])
                
                let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                let tileNode = SKNode()

                
                // MARK: - DEBUG PHYSICS REMOVAL
                
                if debug {
                    let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                    tileNode.physicsBody = physicsBody
                } else {
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                }
                
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                
                if tileTexture.description.contains("Sand") {
                    tileNode.name = "sand\(column)\(row)"
                    tileNode.physicsBody?.categoryBitMask = CollisionType.spikes.rawValue
                }

                tileNode.position = CGPoint(x: x, y: y)

                addChild(tileNode)

                tileNode.position = CGPoint(x: tileNode.position.x + position.x,
                                            y: tileNode.position.y + position.y)
            }
            
            print("\(column)/\(columns)")
            NotificationCenter.default.post(name: progressUpdate, object: nil)
        }
    }
    
    func buildBlackHole() {
        var blackHolePoint = RNGFactory.colRow
        
//        while !availableCoordinates.contains(blackHolePoint) {
//            blackHolePoint = RNGFactory.colRow
//        }
        
        let x = CGFloat(blackHolePoint[0]) * tileSize.width - halfWidth + (tileSize.width / 2)
        let y = CGFloat(blackHolePoint[1]) * tileSize.height - halfHeight + (tileSize.height / 2)

        blackHole.position = CGPoint(x: x, y: y)
    }
    
    func addBlackHole() {
        addChild(blackHole)
    }
    
    func buildCollectibles() {
        for collectible in collectibleSet.collectibles {
            
            if collectible.coords != [0,0] {
                
                let coordIndex = RNGFactory.getSingleAvailablePoint(collectible.index, availableCoordinates.count)
                collectible.coords = availableCoordinates[coordIndex]
//                collectible.coords = RNGFactory.getSingleAvailablePoint(collectible.index, availableCoordinates.count)
                
                let x = CGFloat(collectible.coords[0]) * tileSize.width - halfWidth + (tileSize.width / 2)
                let y = CGFloat(collectible.coords[1]) * tileSize.height - halfHeight + (tileSize.height / 2)
                
                collectible.position = CGPoint(x: x, y: y)
            }
            addChild(collectible)
        }
    }
}

extension MapFactory {
    func teardown() {
        topLayer.eraseTileSet()
        bottomLayer.eraseTileSet()
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
