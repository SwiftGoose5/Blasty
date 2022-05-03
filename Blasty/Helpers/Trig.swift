//
//
//
// Created by Swift Goose on 3/31/22 AT 4:46 PM.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//

import SpriteKit

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
}

func angleDegrees(_ rad: CGFloat) -> CGFloat {
    return rad * 180 / .pi
}

func angleRadians(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
    return CGFloat(-atan2(point1.x - point2.x, point1.y - point2.y))
}

func length(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
    return sqrt(pow(x, 2) + pow(y, 2))
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt(xDist * xDist + yDist * yDist))
}

func getCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Double) -> [CGPoint] {
    let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / n)).map {
        let bearing = CGFloat($0) * .pi / 180
        let x = point.x + radius * cos(bearing)
        let y = point.y + radius * sin(bearing)
        return CGPoint(x: x, y: y)
    }

    return result
}
