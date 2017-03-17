//
//  WTestUtils.swift
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
import UIKit
@testable import WMobileKit

open class UILongPressGestureRecognizerMock: UILongPressGestureRecognizer {
    public var testState: UIGestureRecognizerState!
    public var returnPoint: CGPoint?


    open override var state: UIGestureRecognizerState {
        return testState
    }


    open override func locationInView(view: UIView?) -> CGPoint {
        return returnPoint ?? CGPointZero
    }
}

open class UIPanGestureRecognizerMock: UIPanGestureRecognizer {
    open var testState: UIGestureRecognizerState!
    open var returnPoint: CGPoint?
    open var returnVelocity: CGPoint?

    open override var state: UIGestureRecognizerState {
        return testState
    }

    open override func locationInView(view: UIView?) -> CGPoint {
        return returnPoint ?? CGPointZero
    }

    open override func velocityInView(view: UIView?) -> CGPoint {
        return returnVelocity ?? CGPointZero
    }
}
