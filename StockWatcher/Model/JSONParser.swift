//
//  JSONParser.swift
//  UIKit
//
//  Created by Arthur Wang on 8/2/22.
//

import Foundation
class JSONParser {
    static func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return [:]
    }
    static func convertToArray(data: Data) -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
