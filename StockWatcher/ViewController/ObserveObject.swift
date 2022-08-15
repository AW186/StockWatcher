//
//  ObserveObject.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/4/22.
//

import Foundation
class ObserveObject: NSObject {
    static var obj = ObserveObject.init()
    @objc dynamic var mouseDown: Bool = false
    private override init() {
        
    }
}
