//
//  ViewController + TabView.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/10/22.
//

import Foundation
extension ViewController: TabViewDelegate {
    func showCashflow() {
        updateTickerDetail(key: self.ticker)
    }
    
    func showIncome() {
        updateTickerDetail(key: self.ticker)
    }
    
    func showBalance() {
        updateTickerDetail(key: self.ticker)
    }
    
    
}
