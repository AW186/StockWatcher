//
//  SearchListView.swift
//  UIKit
//
//  Created by Arthur Wang on 7/30/22.
//

import Foundation
import Cocoa

class SearchListView: NSView {
    private var observation: NSKeyValueObservation?
    private var cells: [NSTextField] = [NSTextField]()
    private var data_: [(String, String)] = [(String, String)]()
    private let cellHeight: CGFloat = 30
    private var hover: Int = -1
    var chooseBlk: (String) -> () = { _ in }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var data: [(String, String)] {
        get {
            return data_
        }
        set (newValue) {
            data_ = newValue
            if (self.superview != nil) {
                self.updateCells()
            }
        }
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setupCells()
        layoutCells()
    }
    override func layout() {
        super.layout()
        layoutCells()
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: window?.contentView)
        updateTint(location: location)
    }
    override func mouseExited(with event: NSEvent) {
        cells.forEach { cell in
            cell.layer?.backgroundColor = NSColor.white.cgColor
        }
        hover = -1
    }

    override func updateTrackingAreas() {
        let options : NSTrackingArea.Options =
            [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (ObserveObject.obj.mouseDown && hover >= 0) {
            chooseBlk(data[hover].0)
        }
    }
}

//setup
extension SearchListView {
    private func setupCells() {
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        data.forEach { val in
            let label = NSTextField()
            label.font = NSFont.systemFont(ofSize: 20)
            label.stringValue = " " + val.0 + "(\(val.1))"
            label.isSelectable = false
            label.textColor = NSColor.black
            cells.append(label)
            addSubview(label)
        }
    }
    
    func setupObserver() {
        ObserveObject.obj.addObserver(self, forKeyPath: "mouseDown", options: [.old, .new], context: nil)
    }
    
    func updateCells() {
        guard cells.count == data.count else {
            setupCells()
            layoutCells()
            return
        }
        for i in 0..<cells.count {
            cells[i].stringValue = " " + data[i].0 + "(\(data[i].1))"
        }
    }
}

//layout
extension SearchListView {
    private func layoutCells() {
        var y: CGFloat = self.bounds.height - cellHeight;
        cells.forEach { cell in
            cell.frame.size.height = cellHeight
            cell.frame.size.width = self.bounds.width
            cell.frame.origin.x = 0
            cell.frame.origin.y = y
            y -= cellHeight
        }
    }
    func sizeToFit() {
        self.frame.size.height = cellHeight * CGFloat(data.count)
    }
}

//interaction
extension SearchListView {
    func updateTint(location: NSPoint) {
        var isHover = false
        for i in 0..<cells.count {
            let cell = cells[i]
            if (cell.frame.contains(location)) {
                cell.layer?.backgroundColor = NSColor.lightGray.cgColor
                hover = i
                isHover = true
            } else {
                cell.layer?.backgroundColor = NSColor.white.cgColor
            }
        }
        hover = isHover ? hover : -1
    }
    func click(location: NSPoint) {
        for i in 0..<cells.count {
            if (cells[i].frame.contains(location)) {
                chooseBlk(data[i].0)
            }
        }
    }
}
