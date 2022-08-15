//
//  Companies.swift
//  UIKit
//
//  Created by Arthur Wang on 8/2/22.
//

import Foundation

class Companies {
    static var tickers: [[String : String]] = []
    static var tickerInitialized = false;
//    static var pause = false
    static func loadData() {
        let path = NSHomeDirectory() + "/tickers.json"
        let url = URL.init(fileURLWithPath: path)
        if !FileManager.default.fileExists(atPath: path) {
            return
//            createLocalStorage()
        }
        else {
            do {
                let data = try Data.init(contentsOf: url)
                tickers = JSONParser.convertToArray(data: data) as! [[String : String]]
            } catch {
                print("read failed")
            }
        }
    }
    static func timePause(seconds: UInt32) {
        sleep(seconds)
    }
    static func createLocalStorage() {
        let path = NSHomeDirectory() + "/tickers.json"
        let url = URL.init(fileURLWithPath: path)
        if (FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)) {
            print("File created successfully.")
        } else {
            print("File not created.")
        }
        Exchanges.initiateCodes()
        while (!Exchanges.initiated) { }
        timePause(seconds: 1)
        Exchanges.codes.forEach { val in
            tickerInitialized = false
            initiateTickers(exchange: val)
            while (!tickerInitialized) {}
            print(val + " finished")
            timePause(seconds: 1)
        }
        tickers.forEach { arg in
            print(arg.description)
        }
        guard let data = try? JSONSerialization.data(withJSONObject: tickers, options: []) else {
            return
        }
        do {
            try data.write(to: url)
            
            print("data have written")
        } catch {
            print("fail to write")
        }
    }
    
    static func initiateTickers(exchange: String) {
        let headers = [
            "X-RapidAPI-Key": "afdc8c1747msh4d613d360d1f407p1e35c2jsnf2a2c93ec668",
            "X-RapidAPI-Host": "yahoofinance-stocks1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoofinance-stocks1.p.rapidapi.com/companies/list-by-exchange?ExchangeCode=\(exchange)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        print("loading: " + exchange)
        var dict: [String: Any] = [:]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                print("Failed")
            } else {
                dict = JSONParser.convertToDictionary(data: data!)!
                print("Succeed\n")
                let newTickers = dict["results"] as! [[String : String]]
                tickers.append(contentsOf: newTickers)
                tickerInitialized = true
            }
        })
        dataTask.resume()
    }
    static func search(term: String, limit: Int) -> [(String, String)] {
        var retval: [(String, String)] = []
        let searchTerm = term.uppercased()
        for i in 0..<tickers.count {
            if (tickers[i]["symbol"]!.contains(searchTerm)) {
                retval.append((tickers[i]["symbol"]!, tickers[i]["companyName"]!))
            }
            if retval.count >= limit {
                break
            }
        }
        return retval
    }
}

