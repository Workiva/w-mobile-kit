//
//  WSwitch.swift
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
import SnapKit

public class WSwitch: UIControl {
    public var barView = WSwitchBarView()
    public var backCircle = WSwitchOutlineCircleView()
    public var frontCircle = UIView()
    
    public var barWidth: CGFloat = 44.0 {
        didSet {
            setupUI()
        }
    }
    
    public var barHeight: CGFloat = 12.0 {
        didSet {
            setupUI()
        }
    }

    public var circleRadius: CGFloat = 10.0 {
        didSet {
            setupUI()
        }
    }
    
    public var on: Bool = false {
        didSet {
            setupUI()
            sendActionsForControlEvents(.ValueChanged)
        }
    }

    // Threshold for touch up events registering
    public var touchThreshold: CGFloat = 25.0
    
    private var animatedFlag = false
    internal var didSlideSwitch = false
    internal var didCommonInit = false
    internal var pressRecognizer: UILongPressGestureRecognizer!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        setupUI()
    }
    
    public override init(frame: CGRect) {
        let newFrame = CGRect(origin: frame.origin, size: CGSize(width: barWidth, height: circleRadius * 2))
        super.init(frame: newFrame)
        
        commonInit()
        setupUI()
    }
    
    public convenience init(_ on: Bool) {
        self.init(frame: CGRectZero)
        
        self.on = on
        setupUI()
    }
    
    public convenience init() {
        self.init(true)
        
        setupUI()
    }

    public func commonInit() {
        addSubview(barView)
        barView.alpha = 0.45

        addSubview(backCircle)

        addSubview(frontCircle)
        frontCircle.backgroundColor = .whiteColor()
        
        pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WSwitch.switchWasPressed(_:)))
        pressRecognizer.minimumPressDuration = 0.001
        addGestureRecognizer(pressRecognizer)

        didCommonInit = true
    }

    public func setupUI() {
        if (!didCommonInit) {
            return
        }
        
        barView.snp_remakeConstraints { make in
            make.width.equalTo(barWidth)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(barHeight)
        }

        backCircle.snp_remakeConstraints { make in
            if (on) {
                make.right.equalTo(barView)
            } else {
                make.left.equalTo(barView)
            }
            
            make.centerY.equalTo(self)
            make.height.equalTo(circleRadius * 2)
            make.width.equalTo(circleRadius * 2)
        }

        frontCircle.snp_remakeConstraints { make in
            make.centerX.equalTo(backCircle)
            make.centerY.equalTo(backCircle)
            make.height.equalTo(backCircle).offset(-2)
            make.width.equalTo(backCircle).offset(-2)
        }
        
        let startingBlock = {
            self.frontCircle.alpha = self.on ? 1.0 : 0.0
        }

        if (animatedFlag) {
            animatedFlag = false
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState],
                animations: {
                    self.layoutIfNeeded()
                    startingBlock()
                },
                completion: nil
            )
        } else {
            startingBlock()
            layoutIfNeeded()
        }
        
        backCircle.clipsToBounds = true
        frontCircle.clipsToBounds = true
        barView.clipsToBounds = true
        
        barView.layer.cornerRadius = barView.frame.size.height / 2
        backCircle.layer.cornerRadius = backCircle.frame.size.width / 2
        frontCircle.layer.cornerRadius = frontCircle.frame.size.width / 2

        invalidateIntrinsicContentSize()
    }
    
    public func setOn(on: Bool, animated: Bool) {
        animatedFlag = animated
        self.on = on
    }
    
    public func switchWasPressed(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            frontCircle.alpha = 0.5
        case .Changed:
            let distance: CGFloat = sender.locationInView(superview).distanceToPoint(center)
            if distance > touchThreshold {
                // User has dragged too far. Cancelling touch gesture.
                sender.cancelGesture()
                break
            }

            if (sender.locationInView(self).x > ((frame.size.width / 2) + 5) && !on) {
                setOn(true, animated: true)
                didSlideSwitch = true
            } else if (sender.locationInView(self).x < ((frame.size.width / 2) - 5) && on) {
                setOn(false, animated: true)
                didSlideSwitch = true
            } else {
                frontCircle.alpha = 0.5
            }
        case .Ended:
            if (!didSlideSwitch) {
                setOn(!on, animated: true)
            } else {
                frontCircle.alpha = on ? 1.0 : 0.0
                didSlideSwitch = false
            }
        case .Cancelled, .Failed:
            frontCircle.alpha = on ? 1.0 : 0.0
            didSlideSwitch = false
        default:
            break
        }
    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: barWidth, height: max(barHeight, circleRadius * 2))
    }
}

public class WSwitchOutlineCircleView: UIView { }

public class WSwitchBarView: UIView { }
