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

class SkyFactory: SKNode {

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
        
        self.xScale = 4
        self.yScale = 4
        self.alpha = 0.3
        self.zPosition = -5
        
        noiseMap = makeNoiseMap(columns: columns, rows: rows)
        
        tileSize = CGSize(width: size, height: size)
        
        halfWidth = CGFloat(columns) / 2.0 * tileSize.width
        halfHeight = CGFloat(rows) / 2.0 * tileSize.height
        
        tileSet = SKTileSet(named: "StockTile")!
        waterTiles = tileSet.tileGroups.first { $0.name == "Water" }!
        grassTiles = tileSet.tileGroups.first { $0.name == "Grass" }!
        sandTiles = tileSet.tileGroups.first { $0.name == "Sand" }!
        cobbleTiles = tileSet.tileGroups.first { $0.name == "Cobblestone" }!
        
        bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        topLayer.enableAutomapping = true
//        bottomLayer.fill(with: waterTiles)
        bottomLayer.fill(with: sandTiles)
        
        buildTileSet()
        
        DispatchQueue.main.async {
            self.addChild(self.topLayer)
            self.addChild(self.bottomLayer)
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkyFactory {
    func buildTileSet() {
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                
                let location = vector2(Int32(row), Int32(column))
                let terrainHeight = noiseMap.value(at: location)

                if terrainHeight < 0.6 {
//                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                    
                } else {
//                    topLayer.setTileGroup(sandTiles, forColumn: column, row: row)
                    topLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                }
            }
        }
    }
}

// MARK: - Noise Map

extension SkyFactory {
    func makeNoiseMap(columns: Int, rows: Int, seed: Int32 = DateFactory.dateSeed) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 1
        source.seed = seed

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
}
