//
//  SeachBarDataSource.swift
//  UIKit
//
//  Created by Arthur Wang on 7/29/22.
//

import Foundation

protocol SearchBarDataSource {
    func search(key: String) -> [(String, String)]
}
