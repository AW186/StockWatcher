//
//  ViewController + XYGraph.swift
//  UIKit
//
//  Created by Arthur Wang on 7/26/22.
//

import Foundation
import Cocoa

extension ViewController: XYChartDataSource {
    func getXYData() -> [([CGPoint], NSColor)] {
        [(self.graphData, NSColor.blue)]
    }
    func getXYData(by set: Int) {
        
    }
}

extension ViewController: XYChartDelegate {
    func axisXFormat(val: CGFloat) -> String {
        return UnitConvertion.timeToString(time: TimeInterval(val), format: "YYYY-MM-dd")
    }
    
    func axisYFormat(val: CGFloat) -> String {
        return String(format: "%.2f", Double(val))
    }
    
    func getRange() -> (CGFloat, CGFloat) {
        return range
    }
    
    func getDomain() -> (CGFloat, CGFloat) {
        return domain
    }
    
    func select(line: Int) {
        
    }
}
