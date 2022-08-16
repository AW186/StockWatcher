//
//  TimePeriodTabsDelegate.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/16/22.
//

import Foundation

protocol TimePeriodTabsDelegate {
    func processTimePeriod(period: TimeInterval, interval: String)
}
