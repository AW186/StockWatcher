//
//  XYChartDelegate.swift
//  UIKit
//
//  Created by Arthur Wang on 7/12/22.
//

import Foundation

protocol XYChartDelegate {
    func select(line: Int)
    func getRange() -> (CGFloat, CGFloat)
    func getDomain() -> (CGFloat, CGFloat)
    func axisXFormat(val: CGFloat) -> String
    func axisYFormat(val: CGFloat) -> String
}
