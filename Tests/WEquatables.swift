//
//  WEquatables.swift
//  WMobileKit
//
//  All extensions on C Types to conform to `Equatable` should live in here.

import UIKit

extension CGColor: Equatable {}
public func ==(lhs: CGColor, rhs: CGColor) -> Bool {
    return CGColorEqualToColor(lhs, rhs)
}

extension CGPath: Equatable {}
public func ==(lhs: CGPath, rhs: CGPath) -> Bool {
    return CGPathEqualToPath(lhs, rhs)
}