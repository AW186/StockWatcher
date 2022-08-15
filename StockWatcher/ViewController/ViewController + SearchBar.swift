//
//  ViewController+SearchBar.swift
//  UIKit
//
//  Created by Arthur Wang on 7/30/22.
//

import Foundation
import Cocoa
extension ViewController: SearchBarDelegate {
    
    private func processPriceData(data: Data) {
        let dict = JSONParser.convertToDictionary(data: data)
        guard let priceHistory = dict?["results"] as? [[String : Any]] else {
            return
        }
        if (priceHistory.count == 0) {
            print("ticker not found")
            return
        }
        var max: CGFloat = 0
        var min: CGFloat = priceHistory[0]["o"] as! CGFloat
        self.graphData = [CGPoint].init(repeating: CGPoint(), count: priceHistory.count)
        for i in 0..<priceHistory.count {
            let y = priceHistory[i]["o"] as! CGFloat
            let x = (priceHistory[i]["t"] as! TimeInterval) / 1000
            self.graphData[i] = CGPoint.init(x: x, y: y)
            print(UnitConvertion.timeToString(time: x, format: "YYYY-MM-dd"))
            min = y < min ? y : min
            max = y > max ? y : max
        }
        self.range = (min, max)
        self.domain = ((priceHistory[0]["t"] as! CGFloat) / 1000, (priceHistory[priceHistory.count-1]["t"] as! CGFloat) / 1000)
    }
    private func updatePricesGraph(key: String) {
        let start = UnitConvertion.fiveYearsAgo(format: "YYYY-MM-dd")
        let end = UnitConvertion.timeToString(time: NSDate().timeIntervalSince1970, format: "YYYY-MM-dd")
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.polygon.io/v2/aggs/ticker/\(key)/range/1/day/\(start)/\(end)?adjusted=true&sort=asc&limit=50000&apiKey=rew9uH5wJOVt5PIDtpnDWzm92zye9_aX")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        var finished = false
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                self.processPriceData(data: data!)
                finished = true
            }
        })

        dataTask.resume()
        print("processing " + key)
        while(!finished) {}
        self.updateGraph()
    }
    private func processTickerDetail(data: Data) -> [String : String] {
        let dict = JSONParser.convertToDictionary(data: data)
        guard (dict?["results"] as? [Any])?.count ?? 0 > 0 else {
            return [:]
        }
        guard let results = (dict?["results"] as? [Any])?[0] as? [String : Any] else {
            print("failed")
            return [:]
        }
//        print(results)
        let opt: String = {
            switch self.tabs.option {
                case .balance:
                    return "balance_sheet"
                case .cashflow:
                    return "cash_flow_statement"
                case .income:
                    return "income_statement"
            }
        }()
        guard let detail = (results["financials"] as? [String : Any])?[opt] as? [String : Any] else {
            return [:]
        }
        self.dictionaryView.data.removeAll()
        var retval: [String : String] = [:]
        detail.forEach { key, value in
            let valueDict = value as! [String : Any]
            let strVal = "\(valueDict["value"] as! Double) "
                + (valueDict["unit"] as! String)
            retval[valueDict["label"] as! String] = strVal
        }
        return retval
    }
    func updateTickerDetail(key: String) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.polygon.io/vX/reference/financials?ticker=\(key)&timeframe=annual&limit=1&sort=filing_date&apiKey=rew9uH5wJOVt5PIDtpnDWzm92zye9_aX")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        var retval: [String : String] = [:]
        var finished = false
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                retval = self.processTickerDetail(data: data!)
                finished = true
            }
        })

        dataTask.resume()
        print("processing " + key)
        while(!finished) {}
        self.dictionaryView.data = retval
    }
    func search(key: String) {
        self.ticker = key
        if key.isEmpty {
            return
        }
        updatePricesGraph(key: key)
        updateTickerDetail(key: key)
    }
    
    func placeHold() -> String {
        return "Please enter the ticker"
    }
    
    func cellColor() -> NSColor {
        return NSColor.white
    }
    
    func hoverColor() -> NSColor {
        return NSColor.lightGray
    }
    
    func clickColor() -> NSColor {
        return NSColor.darkGray
    }
    
    
}

extension ViewController: SearchBarDataSource {
    func search(key: String) -> [(String, String)] {
        return Companies.search(term: key, limit: 5)
    }
}