//
//  WSwitch.swift
//  WMobileKit

import Foundation
import UIKit
import SnapKit

public class WSwitch: UIControl {
    public var barView = WSwitchBarView()
    public var backCircle = WSwitchOutlineCircleView()
    public var frontCircle = UIView()
    public var pressRecognizer: UILongPressGestureRecognizer!
    
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
            if (oldValue != on) {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    private var animatedFlag = false
    private var didSlideSwitch = false
    
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
        pressRecognizer.minimumPressDuration = 0.01
        addGestureRecognizer(pressRecognizer)
        
        bounds = CGRect(origin: bounds.origin, size: CGSize(width: barWidth, height: circleRadius * 2))
    }

    public func setupUI() {
        if (!subviews.contains(barView)) {
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
        
        let startingBlock: (Void) -> Void = {
            if (self.on) {
                self.frontCircle.alpha = 1.0
            } else {
                self.frontCircle.alpha = 0.0
            }
        }
        
        let finishedBlock: (Void) -> Void = {
            if (!self.on) {
                self.frontCircle.hidden = true
            }
        }
        
        frontCircle.hidden = false

        if (animatedFlag) {
            animatedFlag = false
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState],
                animations: {
                    self.layoutIfNeeded()
                    startingBlock()
                },
                completion: { finished in
                    finishedBlock()
                }
            )
        } else {
            startingBlock()
            layoutIfNeeded()
            finishedBlock()
        }
        
        backCircle.clipsToBounds = true
        frontCircle.clipsToBounds = true
        barView.clipsToBounds = true
        
        barView.layer.cornerRadius = barView.frame.size.height / 2
        backCircle.layer.cornerRadius = backCircle.frame.size.width / 2
        frontCircle.layer.cornerRadius = frontCircle.frame.size.width / 2
    }
    
    public func setOn(on: Bool, animated: Bool) {
        animatedFlag = animated
        self.on = on
    }
    
    public func switchWasPressed(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .Changed:
            if (sender.locationInView(self).x > frame.size.width / 2 && !on) {
                setOn(true, animated: true)
                didSlideSwitch = true
            } else if (sender.locationInView(self).x < frame.size.width / 2 && on) {
                setOn(false, animated: true)
                didSlideSwitch = true
            }
            break
        case .Ended:
            if (!didSlideSwitch) {
                setOn(!on, animated: true)
            }
            didSlideSwitch = false
        default:
            break
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: barWidth, height: circleRadius * 2)
    }
}

public class WSwitchOutlineCircleView: UIView { }

public class WSwitchBarView: UIView { }
