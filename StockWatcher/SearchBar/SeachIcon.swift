//
//  SeachIcon.swift
//  UIKit
//
//  Created by Arthur Wang on 7/29/22.
//

import Foundation
import Cocoa

class SearchIcon: NSView {
    private let ratio = 0.6
    private var pColor: NSColor = NSColor.lightGray
    var color: NSColor {
        get {
            return pColor
        }
        set (newValue) {
            pColor = newValue
        }
    }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.bounds.size.height -= 2
        self.bounds.size.width -= 2
        let radius = (self.bounds.height*ratio) / (1 + sqrt(2)) * sqrt(2)
        let path = NSBezierPath.init()
        let start = NSPoint.init(x: self.bounds.width*(1-ratio), y: self.bounds.height*(1-ratio))
        let center = NSPoint.init(x: self.bounds.width-radius, y: self.bounds.height-radius)
        path.appendArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 359)
        path.move(to: start)
        path.line(to: CGPoint.init(x: 2, y: 2))
        path.lineWidth = 3
        pColor.setStroke()
        path.stroke()
        self.bounds.size.height += 2
        self.bounds.size.width += 2
    }
}
