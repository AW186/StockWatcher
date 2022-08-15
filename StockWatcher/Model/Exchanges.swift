//
//  Exchanges.swift
//  UIKit
//
//  Created by Arthur Wang on 8/2/22.
//

import Foundation

class Exchanges {
    static var codes: [String] = []
    static var initiated = false
    static func initiateCodes() {
        let headers = [
            "X-RapidAPI-Key": "afdc8c1747msh4d613d360d1f407p1e35c2jsnf2a2c93ec668",
            "X-RapidAPI-Host": "yahoofinance-stocks1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoofinance-stocks1.p.rapidapi.com/exchanges")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                Exchanges.codes = Exchanges.init(with: data!).data
                initiated = true
                print(Exchanges.codes)
            }
        })

        dataTask.resume()
    }
    var data: [String]
    
    init(with json: Data) {
        guard let dict = JSONParser.convertToDictionary(data: json) else {
            data = []
            return
        }
        data = (dict["results"] as! [NSDictionary]).map { pair in
            return pair["exchangeCode"] as! String
        }
    }
    
}
