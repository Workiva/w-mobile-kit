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
import zlib

public extension String {
    // Returns the concatenation of the first letter of each word in a string
    public func initials(_ limit: Int = 3) -> String {
        let range = startIndex..<endIndex
        var initials = String()

        enumerateSubstrings(in: range, options: NSString.EnumerationOptions.byWords) { (substring, _, _, stop) -> () in
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
        if let data = self.data(using: .utf8) {
            let crc = data.withUnsafeBytes { crc32(0, $0, numericCast(data.count)) }
            return UInt(crc)
        }

        return 0
    }
}

public extension CGPoint {
    func distanceToPoint(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(x-point.x, 2) + pow(y-point.y, 2));
    }
}

public extension UILongPressGestureRecognizer {
    func cancelGesture() {
        isEnabled = false
        isEnabled = true
    }
}

public extension UILabel {
    /// Calculates the current number of lines for a label. 
    public func dynamicLineCount() -> Int {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = frame.size.height
        paragraphStyle.maximumLineHeight = frame.size.height
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle]

        let size = text!.size(withAttributes: attributes)
        let stringWidth = size.width

        let constrainedSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))

        if ((constrainedSize.width == 0) || (stringWidth == 0)) {
            return 1
        }
        
        return Int(ceil(Double(stringWidth/constrainedSize.width)))
    }
}

public extension UIApplication {
    func isRunningInFullScreen() -> Bool {
        if let w = self.keyWindow {
            let maxScreenSize = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            let minScreenSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            let maxAppSize = max(w.bounds.size.width, w.bounds.size.height)
            let minAppSize = min(w.bounds.size.width, w.bounds.size.height)
            return maxScreenSize == maxAppSize && minScreenSize == minAppSize
        }
        return true
    }
}
