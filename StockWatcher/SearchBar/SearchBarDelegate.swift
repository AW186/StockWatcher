//
//  SearchBarDelegation.swift
//  UIKit
//
//  Created by Arthur Wang on 7/29/22.
//

import Foundation
import AppKit

protocol SearchBarDelegate {
    func search(key: String)
    func placeHold() -> String
    func cellColor() -> NSColor
    func hoverColor() -> NSColor
    func clickColor() -> NSColor
}
