//
//  WTestUtils.swift
//  WMobileKit

import Foundation
import UIKit
@testable import WMobileKit

public class UILongPressGestureRecognizerMock : UILongPressGestureRecognizer {
    public var testState: UIGestureRecognizerState!
    public var slideLeft: Bool = true

    public override var state: UIGestureRecognizerState {
        return testState
    }

    public override func locationInView(view: UIView?) -> CGPoint {
        if view != nil {
            if view!.isKindOfClass(WSwitch) {
                if !slideLeft {
                    return CGPoint(x: view!.frame.origin.x + view!.frame.size.width, y: view!.frame.origin.y)
                }

                return CGPointZero
            }
        }

        return CGPointZero
    }
}
