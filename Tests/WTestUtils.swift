//
//  WTestUtils.swift
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
import UIKit
@testable import WMobileKit

public class UILongPressGestureRecognizerMock: UILongPressGestureRecognizer {
    public var testState: UIGestureRecognizerState!
    public var returnPoint: CGPoint?

    public override var state: UIGestureRecognizerState {
        return testState
    }

    public override func locationInView(view: UIView?) -> CGPoint {
        return returnPoint ?? CGPointZero
    }
    
//    public override func locationInView(view: UIView?) -> CGPoint {
//        if view != nil {
//            if view!.isKindOfClass(WSwitch) {
//                if !slideLeft {
//                    return CGPoint(x: view!.frame.origin.x + view!.frame.size.width, y: view!.frame.origin.y)
//                }
//
//                return CGPointZero
//            }
//        }
//
//        return CGPointZero
//    }
}

public class UIPanGestureRecognizerMock: UIPanGestureRecognizer {
    public var testState: UIGestureRecognizerState!
    public var returnPoint: CGPoint?
    public var returnVelocity: CGPoint?

    public override var state: UIGestureRecognizerState {
        return testState
    }

    public override func locationInView(view: UIView?) -> CGPoint {
        return returnPoint ?? CGPointZero
    }

    public override func velocityInView(view: UIView?) -> CGPoint {
        return returnVelocity ?? CGPointZero
    }
}
