//
//  XYGraph.swift
//  UIKit
//
//  Created by Arthur Wang on 7/12/22.
//

import Foundation
import Cocoa

class XYGraph: NSView {
    
    private var lines: [([CGPoint], NSColor)]
    var data: [([CGPoint], NSColor)] {
        get {
            return lines
        }
        set(value) {
            lines = value
            self.setNeedsDisplay(self.bounds)
        }
    }
    var paths: [NSBezierPath] = [NSBezierPath].init()
    init(frame frameRect: NSRect, lines: [([CGPoint], NSColor)]) {
        self.lines = lines
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layout() {
        super.layout()
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawAxis()
        drawData()
    }
    func drawAxis() {
        let axis: NSBezierPath = NSBezierPath.init();
        axis.move(to: NSPoint.init(x: 0, y: bounds.height))
        axis.line(to: NSPoint.init(x: 0, y: 0))
        axis.line(to: NSPoint.init(x: bounds.width, y: 0))
        axis.lineWidth = 3
        NSColor.red.setStroke()
        axis.stroke()
    }
    func drawData() {
        paths.removeAll()
        lines.forEach { line in
            line.1.setStroke()
            let path = NSBezierPath.init()
            path.move(to: line.0[0].scale(size: self.bounds.size))
            line.0.forEach { point in
                path.line(to: point.scale(size: self.bounds.size))
            }
            path.lineWidth = 1
            path.stroke()
        }
    }
}
