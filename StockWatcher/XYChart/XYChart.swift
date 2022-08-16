//
//  XYChart.swift
//  UIKit
//
//  Created by Arthur Wang on 7/12/22.
//

import Foundation
import Cocoa

class XYChart: NSView {
    var delegate: XYChartDelegate?
    var dataSource: XYChartDataSource?
    private var padding: CGFloat = 55
    private var bottomGap: CGFloat = 30
    private var horizontalSeperation = 5
    private var verticalSeperation = 5
    private var domain: (CGFloat, CGFloat) = (0, 1)
    private var range: (CGFloat, CGFloat) = (0, 1)
    private var xLabels: [NSTextField] = [NSTextField]()
    private var yLabels: [NSTextField] = [NSTextField]()
    private lazy var graph: XYGraph  = {
        var frame = self.bounds
        frame.origin.x += padding
        frame.origin.y += bottomGap
        frame.size.width -= 2 * padding
        frame.size.height -= 2 * padding
        let view =
            XYGraph.init(frame: frame,
                         lines: dataSource?.getXYData() ?? [([CGPoint], NSColor)].init())
        view.wantsLayer = true
        return view
    }()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        setupGraph()
        setupAxis()
    }
    
    override func layout() {
        super.layout()
        layoutGraph()
        layoutLabels()
    }
    
}

//setup
extension XYChart {
    private func setupAxis() {
        range = delegate?.getRange() ?? range
        domain = delegate?.getDomain() ?? domain
        setupXAxis()
        setupYAxis()
    }
    private func setupXAxis() {
        xLabels.forEach { arg in
            arg.removeFromSuperview()
        }
        xLabels.removeAll()
        let space = graph.frame.width / CGFloat(horizontalSeperation)
        let increment = (domain.1 - domain.0) / CGFloat(horizontalSeperation)
        for i in 0...horizontalSeperation {
            let val = CGFloat(i) * increment + domain.0
            let text = delegate?.axisXFormat(val: val) ?? String(Double(val))
            let label = NSTextField.init(labelWithString: text)
            label.font = NSFont.systemFont(ofSize: 12)
            label.alignment = .center
            label.textColor = NSColor.black
            xLabels.append(label)
            self.addSubview(label)
        }
    }
    private func setupYAxis() {
        let space = graph.frame.height / CGFloat(verticalSeperation)
        let increment = (range.1 - range.0) / CGFloat(verticalSeperation)
        for i in 0...verticalSeperation {
            let val = CGFloat(i) * increment + range.0
            let text = delegate?.axisYFormat(val: val) ?? String(Double(val))
            let label = NSTextField.init(labelWithString: text)
            label.font = NSFont.systemFont(ofSize: 12)
            label.alignment = .center
            label.textColor = NSColor.black
            yLabels.append(label)
            self.addSubview(label)
        }
    }
    private func setupGraph() {
        graph.removeFromSuperview()
        self.addSubview(graph)
    }
}

//layout
extension XYChart {
    private func layoutGraph() {
        var frame = self.bounds
        frame.origin.x += padding
        frame.origin.y += bottomGap
        frame.size.width -= 2 * padding
        frame.size.height -= 2 * padding
        graph.frame = frame
        updateLines()
    }
    private func layoutLabels() {
        layoutXAxis()
        layoutYAxis()
    }
    private func layoutXAxis() {
        let space = graph.frame.width / CGFloat(horizontalSeperation)
        let increment = (domain.1 - domain.0) / CGFloat(horizontalSeperation)
        for i in 0...horizontalSeperation {
            
            xLabels[i].font = NSFont.systemFont(ofSize: 12)
            xLabels[i].sizeToFit()
            xLabels[i].frame.origin = CGPoint.init(x: padding - xLabels[i].frame.width / 2 + CGFloat(i) * space, y: 0)
            
            xLabels[i].frame.size.height = bottomGap
        }
    }
    private func layoutYAxis() {
        let space = graph.frame.height / CGFloat(verticalSeperation)
        let increment = (range.1 - range.0) / CGFloat(verticalSeperation)
        for i in 0...verticalSeperation {
            yLabels[i].frame.origin = CGPoint.init(x: 0, y: bottomGap + CGFloat(i) * space)
            yLabels[i].frame.size.width = padding
            yLabels[i].sizeToFit()
        }
    }
}

//data
extension XYChart {
    private func getLines() -> [([CGPoint], NSColor)]{
        let retval = dataSource?.getXYData() ?? [([CGPoint], NSColor)].init()
        return retval.map { arg -> ([CGPoint], NSColor) in
            var newVal = arg
            newVal.0 = arg.0.map {point -> CGPoint in
                return CGPoint.init(
                    x: rangeVal(range: domain, val: point.x),
                    y: rangeVal(range: range, val: point.y))
            }
            return newVal
        }
    }
    private func rangeVal(range: (CGFloat, CGFloat), val: CGFloat) -> CGFloat{
        return (val-range.0)/(range.1 - range.0)
    }
    private func updateLines() {
        range = delegate?.getRange() ?? range
        domain = delegate?.getDomain() ?? domain
        graph.data = getLines()
    }
}
