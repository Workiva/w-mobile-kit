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

open class UILongPressGestureRecognizerMock : UILongPressGestureRecognizer {
    open var testState: UIGestureRecognizerState!
    open var slideLeft: Bool = true

    open override var state: UIGestureRecognizerState {
        return testState
    }

    open override func location(in view: UIView?) -> CGPoint {
        if view != nil {
            if view! is WSwitch {
                if !slideLeft {
                    return CGPoint(x: view!.frame.origin.x + view!.frame.size.width, y: view!.frame.origin.y)
                }

                return CGPoint.zero
            }
        }

        return CGPoint.zero
    }
}
