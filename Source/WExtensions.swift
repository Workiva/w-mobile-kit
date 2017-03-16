//
//  WExtensions.swift
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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

public extension UILabel {
    /// Calculates the current number of lines for a label. 
    public func dynamicLineCount() -> Int {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = frame.size.height
        paragraphStyle.maximumLineHeight = frame.size.height
        paragraphStyle.lineBreakMode = .ByWordWrapping
        let attributes: [String: AnyObject] = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle]

        let size = text!.sizeWithAttributes(attributes)
        let stringWidth = size.width

        let constrainedSize = CGSizeMake(frame.size.width, CGFloat(Float.infinity))

        if ((constrainedSize.width == 0) || (stringWidth == 0)) {
            return 1
        }
        
        return Int(ceil(Double(stringWidth/constrainedSize.width)))
    }
}

public extension UIApplication {
    func isRunningInFullScreen() -> Bool {
        if let w = self.keyWindow {
            let maxScreenSize = max(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            let minScreenSize = min(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            let maxAppSize = max(w.bounds.size.width, w.bounds.size.height)
            let minAppSize = min(w.bounds.size.width, w.bounds.size.height)
            return maxScreenSize == maxAppSize && minScreenSize == minAppSize
        }
        return true
    }
}
