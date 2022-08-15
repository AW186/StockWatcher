//
//  SearchBar.swift
//  UIKit
//
//  Created by Arthur Wang on 7/29/22.
//

import Foundation
import Cocoa

class SearchBar: NSView {
    let delegate: SearchBarDelegate
    let dataSource: SearchBarDataSource
    var maximumResultsShow = 5
    private let searchList: SearchListView = SearchListView()
    private let inputLeftSpace: CGFloat = 40
    private let input: NSTextField = NSTextField.init()
    private let icon: SearchIcon = SearchIcon.init(frame: NSRect.init(origin: CGPoint.init(), size: CGSize.init(width: 30, height: 30)))
    init(frame frameRect: NSRect, delegate: SearchBarDelegate, dataSource: SearchBarDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        super.init(frame: frameRect)
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setupIcon()
        setupInput()
        setupSearchList()
    }
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        let editor = self.window!.fieldEditor(true, for: input) as! NSTextView
        editor.insertionPointColor = NSColor.black
    }
    override func layout() {
        super.layout()
        layoutIcon()
        layoutInput()
        layoutSearchList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//setup
extension SearchBar {
    private func setupIcon() {
        icon.removeFromSuperview()
        icon.color = NSColor.lightGray
        self.addSubview(icon)
    }
    override func mouseDown(with event: NSEvent) {
        print("mouse: \(NSEvent.mouseLocation)")
    }
    private func setupInput() {
        input.removeFromSuperview()
        input.backgroundColor = NSColor.white
        input.placeholderString = delegate.placeHold()
        input.isSelectable = true
        input.isEditable = true
        input.isBezeled = true
        input.isEnabled = true
        input.textColor = NSColor.black
        input.alignment = .left
        input.delegate = self
        setupInputShadow()
        self.addSubview(input)
    }
    private func setupInputShadow() {
        input.layer?.masksToBounds = false
        input.shadow = NSShadow()
        input.layer?.backgroundColor = NSColor.white.cgColor
        input.layer?.shadowColor = NSColor.black.cgColor
        input.layer?.shadowOpacity = 0.2
        input.layer?.shadowOffset = CGSize(width: 0, height: 0)
        input.layer?.shadowRadius = 5
        
    }
    private func setupSearchListShadow() {
        searchList.layer?.masksToBounds = false
        searchList.shadow = NSShadow()
        searchList.layer?.backgroundColor = NSColor.white.cgColor
        searchList.layer?.shadowColor = NSColor.black.cgColor
        searchList.layer?.shadowOpacity = 0.2
        searchList.layer?.shadowOffset = CGSize(width: 0, height: 0)
        searchList.layer?.shadowRadius = 5
        searchList.chooseBlk = { val in
            self.removeSearchList()
            self.delegate.search(key: val)
        }
    }
    private func setupSearchList() {
        searchList.removeFromSuperview()
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        searchList.wantsLayer = true
        setupSearchListShadow()
    }
}
//layout
extension SearchBar {
    private func layoutIcon() {
        icon.frame.origin = self.bounds.origin
    }
    private func layoutInput() {
        input.frame.origin = NSPoint.init(x: inputLeftSpace, y: 0)
        input.frame.size = NSSize.init(width: self.bounds.width-inputLeftSpace, height: self.bounds.height)
        
        input.font = NSFont.systemFont(ofSize: input.frame.height / 3 * 2)
    }
    private func layoutSearchList() {
        searchList.frame.size.width = self.bounds.width-inputLeftSpace
        searchList.sizeToFit()
        searchList.frame.origin = NSPoint.init(x: inputLeftSpace, y: -searchList.frame.height)
    }
}

extension SearchBar {
    private func showSearchList() {
        searchList.removeFromSuperview()
        self.addSubview(searchList)
        layoutSearchList()
    }
    private func removeSearchList() {
        searchList.removeFromSuperview()
    }
}

extension SearchBar: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        searchList.data = dataSource.search(key: input.stringValue)
        if (input.stringValue.isEmpty) {
            removeSearchList()
        } else if (searchList.superview == nil) {
            showSearchList()
        }
    }
    func controlTextDidEndEditing(_ obj: Notification) {
        self.removeSearchList()
        delegate.search(key: input.stringValue.uppercased())
    }
    
    func controlTextDidBeginEditing(_ obj: Notification) {
        
    }
}




