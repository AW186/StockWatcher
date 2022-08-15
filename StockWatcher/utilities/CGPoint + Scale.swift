//
//  CGPoint + Scale.swift
//  UIKit
//
//  Created by Arthur Wang on 7/13/22.
//

import Foundation
import Cocoa

extension CGPoint {
    func scale(size: NSSize) -> CGPoint {
        return CGPoint(x: self.x * size.width, y: self.y * size.height)
    }
    func scale(size: NSRect) -> CGPoint {
        return CGPoint(x: self.x * size.width + size.minX, y: self.y * size.height + size.minY)
    }
    func plus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    func minus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
}
