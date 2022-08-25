//
//  XYChartDataSource.swift
//  UIKit
//
//  Created by Arthur Wang on 7/12/22.
//

import Foundation
import AppKit

protocol XYChartDataSource {
    func getXYData() -> [([CGPoint], NSColor)]
    func getXYData(by set: Int)
    func getXAxisLabels() -> [String]
}
