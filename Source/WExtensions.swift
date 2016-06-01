//
//  WExtensions.swift
//  WMobileKit

import Foundation

public extension String {
    // Returns the concatenation of the first letter of each word in a string
    public func initials(limit: Int = 3) -> String {
        let range = startIndex..<endIndex
        var initials = String()

        enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByWords) { (substring, _, _, stop) -> () in
            let initial = substring!.characters.first! as Character
            initials = initials + String(initial)
            if (initials.characters.count >= limit) {
                stop = true
            }
        }

        return initials
    }

    // Returns the CRC32 checksum for a string as an int
    public func crc32int() -> UInt {
        return strtoul(crc32(), nil, 16)
    }
}

public extension CGPoint {
    func distanceToPoint(point: CGPoint) -> CGFloat {
        return sqrt(pow(x-point.x, 2) + pow(y-point.y, 2));
    }
}

public extension UILongPressGestureRecognizer {
    func cancelGesture() {
        enabled = false
        enabled = true
    }
}