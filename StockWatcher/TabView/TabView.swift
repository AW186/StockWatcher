//
//  TabView.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/6/22.
//

import Foundation
import Cocoa

enum Status: Int {
    case income = 0
    case cashflow = 1
    case balance = 2
}

class TabView: NSView {
    private var status = Status.income
    public var option: Status {
        get {
            return status
        }
    }
    private let btnWidth: CGFloat = 75
    var delegate: TabViewDelegate?
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    private var incomeButton: NSTextField = NSTextField()
    private var cashflowButton: NSTextField = NSTextField()
    private var balanceButton: NSTextField = NSTextField()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setupIncomeButton()
        setupCashflowButton()
        setupBalanceButton()
        setTintIncome()
    }
    override func layout() {
        super.layout()
        layoutIncomeButton()
        layoutCashflowButton()
        layoutBalanceButton()
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let start = CGFloat(status.rawValue) * btnWidth
        let path = NSBezierPath.init()
        path.move(to: NSPoint.init(x: start, y: 0))
        path.line(to: NSPoint.init(x: start + btnWidth, y: 0))
        NSColor.orange.setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}

extension TabView {
    private func setupBalanceButton() {
        balanceButton.removeFromSuperview()
        balanceButton.stringValue = "Balance"
        balanceButton.textColor = NSColor.lightGray
        balanceButton.font = NSFont.systemFont(ofSize: 16)
        balanceButton.alignment = .center
        balanceButton.isEditable = false
        balanceButton.isSelectable = false
        balanceButton.backgroundColor = NSColor.white
        balanceButton.isBordered = false
        let gesture = NSClickGestureRecognizer.init(target: self, action: #selector(balanceAction))
        balanceButton.addGestureRecognizer(gesture)
        self.addSubview(balanceButton)
    }
    private func setupIncomeButton() {
        incomeButton.removeFromSuperview()
        incomeButton.stringValue = "Income"
        incomeButton.textColor = NSColor.lightGray
        incomeButton.font = NSFont.systemFont(ofSize: 16)
        incomeButton.alignment = .center
        incomeButton.isEditable = false
        incomeButton.isSelectable = false
        incomeButton.backgroundColor = NSColor.white
        incomeButton.isBordered = false
        let gesture = NSClickGestureRecognizer.init(target: self, action: #selector(incomeAction))
        incomeButton.addGestureRecognizer(gesture)
        self.addSubview(incomeButton)
    }
    private func setupCashflowButton() {
        cashflowButton.removeFromSuperview()
        cashflowButton.stringValue = "Cashflow"
        cashflowButton.textColor = NSColor.lightGray
        cashflowButton.font = NSFont.systemFont(ofSize: 16)
        cashflowButton.alignment = .center
        cashflowButton.isEditable = false
        cashflowButton.isSelectable = false
        cashflowButton.backgroundColor = NSColor.white
        cashflowButton.isBordered = false
        let gesture = NSClickGestureRecognizer.init(target: self, action: #selector(cashflowAction))
        cashflowButton.addGestureRecognizer(gesture)
        self.addSubview(cashflowButton)
    }
}

extension TabView {
    private func layoutIncomeButton() {
        incomeButton.sizeToFit()
        incomeButton.frame.origin.x = 0
        incomeButton.frame.origin.y = 5
        incomeButton.frame.size.width = btnWidth
    }
    private func layoutCashflowButton() {
        cashflowButton.sizeToFit()
        cashflowButton.frame.origin.x = btnWidth
        cashflowButton.frame.origin.y = 5
        cashflowButton.frame.size.width = btnWidth
    }
    private func layoutBalanceButton() {
        balanceButton.sizeToFit()
        balanceButton.frame.origin.x = btnWidth * 2
        balanceButton.frame.origin.y = 5
        balanceButton.frame.size.width = btnWidth
    }
}

extension TabView {
    @objc private func balanceAction() {
        if status != .balance {
            setTintBalance()
            status = .balance
            delegate?.showBalance()
            self.setNeedsDisplay(self.bounds)
        }
    }
    @objc private func incomeAction() {
        if status != .income {
            setTintIncome()
            status = .income
            delegate?.showIncome()
            self.setNeedsDisplay(self.bounds)
        }
    }
    @objc private func cashflowAction() {
        if status != .cashflow {
            setTintCashflow()
            status = .cashflow
            delegate?.showCashflow()
            self.setNeedsDisplay(self.bounds)
        }
    }
    func setTintIncome() {
        incomeButton.textColor = NSColor.orange
        cashflowButton.textColor = NSColor.lightGray
        balanceButton.textColor = NSColor.lightGray
    }
    func setTintCashflow() {
        cashflowButton.textColor = NSColor.orange
        incomeButton.textColor = NSColor.lightGray
        balanceButton.textColor = NSColor.lightGray
    }
    func setTintBalance() {
        incomeButton.textColor = NSColor.lightGray
        cashflowButton.textColor = NSColor.lightGray
        balanceButton.textColor = NSColor.orange
    }
}
