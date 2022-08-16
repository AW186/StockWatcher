//
//  ViewController + TimePeriodTabs.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/16/22.
//

import Foundation
import Cocoa

extension ViewController: TimePeriodTabsDelegate {
    func processTimePeriod(period: TimeInterval, interval: String) {
        updatePricesGraph(key: self.ticker, time: period, interval: interval)
    }
}
