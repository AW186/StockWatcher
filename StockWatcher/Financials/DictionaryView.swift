//
//  DictionaryView.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/6/22.
//

import Foundation
import Cocoa

class DictionaryView: NSView {
    private let padding: CGFloat = 10
    private let cellHeight: CGFloat = 10
    private let fontSize: CGFloat = 14
    private var contentView: NSClipView = NSClipView()
    private var _data: [String : String] = [:]
    var data: [String : String] {
        get {
            return _data
        }
        set (newValue) {
            if (_data == newValue) {
                return
            }
            _data = newValue
            updateView()
        }
    }
    private var keyLabels: [NSTextView] = []
    private var valueLabels: [NSTextView] = []
    private let scrollView: NSScrollView = NSScrollView()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layout() {
        super.layout()
        layoutSubview()
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setup()
    }
}

extension DictionaryView {
    func setup() {
        setupScrollView()
        setupValues()
        setupKeys()
    }
    func setupScrollView() {
        scrollView.removeFromSuperview()
        self.contentView = NSClipView.init()
        scrollView.backgroundColor = NSColor.white
        contentView.wantsLayer = true
        contentView.backgroundColor = NSColor.white
        scrollView.documentView = self.contentView
        self.addSubview(scrollView)

    }
    func setupKeys() {
        keyLabels.forEach { view in
            view.removeFromSuperview()
        }
        keyLabels.removeAll()
        data.forEach { key, _ in
            let label = NSTextView()
            label.string = key
            label.font = NSFont.systemFont(ofSize: fontSize)
            label.textColor = NSColor.black
            label.backgroundColor = NSColor.white
            label.isEditable = false
            label.alignment = .left
            contentView.addSubview(label)
            keyLabels.append(label)
        }
    }
    func setupValues() {
        valueLabels.forEach { view in
            view.removeFromSuperview()
        }
        valueLabels.removeAll()
        data.forEach { _, value in
            let label = NSTextView()
            label.string = value
            label.font = NSFont.systemFont(ofSize: fontSize)
            label.textColor = NSColor.black
            label.backgroundColor = NSColor.white
            label.isEditable = false
            label.alignment = .right
            contentView.addSubview(label)
            valueLabels.append(label)
        }
    }
}

extension DictionaryView {
    func layoutSubview() {
        layoutScrollView()
        layoutLabels()
        layoutScrollOffset()
    }
    func layoutScrollView() {
        scrollView.frame = self.bounds
        var rect = self.bounds.size
        rect.height = CGFloat(data.count) * cellHeight
        rect.height = max(rect.height, self.bounds.height)
        contentView.frame.size = rect
    }
    func layoutLabels() {
        var height: CGFloat = 0
        for i in 0..<keyLabels.count {
            let keyLabel = keyLabels[i]
            keyLabel.frame.size.width = self.bounds.width/2 - padding
            keyLabel.sizeToFit()
            keyLabel.frame.origin.x = padding
            keyLabel.frame.origin.y = contentView.frame.height - height - keyLabel.frame.height
            keyLabel.sizeToFit()
            keyLabel.frame.size = keyLabel.contentSize
            keyLabel.frame.size.height += cellHeight
            let valueLabel = valueLabels[i]
            valueLabel.frame.size.width = self.bounds.width/2 - padding
            valueLabel.sizeToFit()
            valueLabel.frame.origin.x = self.bounds.width/2
            valueLabel.frame.origin.y = contentView.frame.height - height - valueLabel.frame.height
            valueLabel.frame.size = valueLabel.contentSize
            valueLabel.frame.size.height += cellHeight
            height += max(valueLabel.frame.height, keyLabel.frame.height)
        }
        contentView.frame.size.height = height
    }
    func layoutScrollOffset() {
        if contentView.frame.height < self.bounds.height {
            let difference = self.bounds.height - contentView.frame.height
            contentView.frame.size.height += difference
            keyLabels.forEach { label in
                label.frame.origin.y += difference
            }
            valueLabels.forEach { label in
                label.frame.origin.y += difference
            }
        }
    }
}

extension DictionaryView {
    func updateView() {
        setup()
        layoutSubview()
    }
}
extension NSTextView {

    var contentSize: CGSize {
        get {
            guard let layoutManager = layoutManager, let textContainer = textContainer else {
                print("textView no layoutManager or textContainer")
                return .zero
            }

            layoutManager.ensureLayout(for: textContainer)
            return layoutManager.usedRect(for: textContainer).size
        }
    }
}
