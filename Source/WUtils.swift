//
//  WUtils.swift
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

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

public enum xAlignment {
    case left, center, right
}
public enum yAlignment {
    case top, center, bottom
}

open class WUtils {
    public class func generateExampleViews(count: Int) -> [UIView] {
        var views: [UIView] = []

        if (count < 1) {
            return views
        }

        for _ in 1...count {
            views.append(generateExampleView(minWidthHeight: 30, maxWidthHeight: 120))
        }

        return views
    }

    public class func generateExampleView(minWidthHeight: Int, maxWidthHeight: Int) -> UIView {
        // Size with width and height from min to max
        var min: UInt32!
        var max: UInt32!

        min = (minWidthHeight < 0) ? 0 : UInt32(minWidthHeight)
        max = (maxWidthHeight < 0) ? 0 : UInt32(maxWidthHeight)

        if (max < min) {
            max = min
        }

        let frame = CGRect(x: 0,
                y: 0,
                width: CGFloat(arc4random_uniform(max-min) + min),
                height: CGFloat(arc4random_uniform(max-min) + min))

        let view = UIView(frame: frame)
        view.backgroundColor = getRandomColor()

        return view
    }

    public class func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
