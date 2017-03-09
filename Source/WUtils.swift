//
//  WUtils.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
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

public enum xAlignment {
    case Left, Center, Right
}
public enum yAlignment {
    case Top, Center, Bottom
}

public class WUtils {
    public class func generateExampleViews(count: Int) -> [UIView] {
        var views: [UIView] = []

        for _ in 0...count {
            views.append(generateExampleView(30, maxWidthHeight: 120))
        }

        return views
    }

    public class func generateExampleView(minWidthHeight: Int, maxWidthHeight: Int) -> UIView {
        // Size with width and height from min to max
        let min = UInt32(minWidthHeight)
        var max = UInt32(maxWidthHeight)

        if (max < min) {
            max = min
        }

        let view = UIView(frame: CGRectMake(0, 0, CGFloat(arc4random_uniform(max-min) + min),
                                                  CGFloat(arc4random_uniform(max-min) + min)))
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
