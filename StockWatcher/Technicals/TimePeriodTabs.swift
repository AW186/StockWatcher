//
//  TimePeriodTabs.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/16/22.
//

import Foundation
import Cocoa

enum TimePeriods: TimeInterval {
    case fiveyrs = 157680000
    case oneyr = 31536000
    case sixmonths = 15552000
    case threemonths = 7776000
    case onemonth = 2592000
    case week = 604800
    case day = 86400
    case hour = 3600
    case minutes = 60
}

class TimePeriodTabs: NSView {
    private let periods: [TimePeriods] =
        [.fiveyrs,
         .oneyr,
         .sixmonths,
         .threemonths,
         .onemonth,
         .week,
         .day]
    private var status = TimePeriods.fiveyrs
    public var period: TimePeriods {
        get {
            return status
        }
    }
    private let btnWidth: CGFloat = 75
    var delegate: TimePeriodTabsDelegate?
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    private var buttons: [NSTextField] = []
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setupButtons()
        setTint(index: 0)
        status = .fiveyrs
    }
    override func layout() {
        super.layout()
        layoutButtons()
    }
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let location = convert(event.locationInWindow, from: window?.contentView)
        for i in 0..<buttons.count {
            if buttons[i].frame.contains(location) {
                setActive(index: i)
            }
        }
    }
}

extension TimePeriodTabs {
    private func setupButtons() {
        buttons.forEach { btn in
            btn.removeFromSuperview()
        }
        buttons.removeAll()
        ["5 yrs", "1 yr", "180 days", "90 days", "30 days", "7 days"].forEach { text in
            let btn = NSTextField()
            btn.stringValue = text
            btn.textColor = NSColor.lightGray
            btn.font = NSFont.systemFont(ofSize: 16)
            btn.alignment = .center
            btn.isEditable = false
            btn.isSelectable = false
            btn.backgroundColor = NSColor.white
            btn.isBordered = false
            buttons.append(btn)
            self.addSubview(btn)
        }
    }
}

extension TimePeriodTabs {
    private func layoutButtons() {
        for i in 0..<buttons.count {
            let btn = buttons[i]
            btn.sizeToFit()
            btn.frame.origin.x = CGFloat(i) * btnWidth
            btn.frame.origin.y = 5
            btn.frame.size.width = btnWidth
        }
    }
}

extension TimePeriodTabs {
    private func setActive(index: Int) {
        if status != periods[index] {
            status = periods[index]
            delegate?.processTimePeriod(period: period.rawValue, interval: getInterval())
            setTint(index: index)
        }
    }
    private func setTint(index: Int) {
        buttons.forEach { btn in
            btn.textColor = NSColor.lightGray
        }
        buttons[index].textColor = NSColor.orange
    }
    func getInterval() -> String {
        switch status {
        case .fiveyrs, .oneyr, .threemonths:
            return "day"
        case .day:
            return "minutes"
        default:
            return "hour"
        }
    }
}

