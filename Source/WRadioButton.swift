//
//  WRadioButton.swift
//  WMobileKit

import Foundation
import UIKit
import SnapKit

let MIN_INDICATOR_RADIUS: CGFloat = 1.0
let MIN_RADIO_CIRCLE: CGFloat = 2.0
let wRadioButtonSelected = "wRadioButtonSelected"

public class WRadioCircleView: UIView { }
public class WRadioIndicatorView: UIView { }

public class WRadioButton: UIControl {
    public var radioCircle = WRadioCircleView()
    public var indicatorView = WRadioIndicatorView()

    public var groupID: Int = 0
    public var buttonID: Int = 0

    public var buttonColor: UIColor = .whiteColor() {
        didSet {
            setupUI()
        }
    }

    public var highlightColor: UIColor = .grayColor() {
        didSet {
            setupUI()
        }
    }

    public var indicatorColor: UIColor = .darkGrayColor() {
        didSet {
            setupUI()
        }
    }

    public var borderColor: UIColor = .lightGrayColor() {
        didSet {
            setupUI()
        }
    }

    public var borderWidth: CGFloat = 2 {
        didSet {
            setupUI()
        }
    }

    public var buttonRadius: CGFloat = 12.0 {
        didSet {
            // Lower bounds
            self.indicatorRadius = max(MIN_RADIO_CIRCLE, buttonRadius)

            setupUI()
        }
    }

    public var indicatorRadius: CGFloat = 6.0 {
        didSet {
            // Upper bounds
            indicatorRadius = min(indicatorRadius, (buttonRadius-1))

            // Lower bounds
            indicatorRadius = max(MIN_INDICATOR_RADIUS, indicatorRadius)

            setupUI()
        }
    }

    public override var selected: Bool {
        didSet {
            setupUI()

            if (oldValue != selected) {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }

    private var animatedFlag = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUI()
    }

    public override init(frame: CGRect) {
        let newFrame = CGRect(origin: frame.origin, size: CGSize(width: buttonRadius * 2, height: buttonRadius * 2))
        super.init(frame: newFrame)

        commonInit()
        setupUI()
    }

    public convenience init(_ selected: Bool) {
        self.init(frame: CGRectZero)

        self.selected = selected
        setupUI()
    }

    public convenience init() {
        // Default to not selected
        self.init(false)

        setupUI()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public func commonInit() {
        addSubview(radioCircle)
        radioCircle.backgroundColor = buttonColor

        addSubview(indicatorView)
        indicatorView.backgroundColor = indicatorColor

        var pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WRadioButton.buttonWasPressed(_:)))
        pressRecognizer.minimumPressDuration = 0.001
        addGestureRecognizer(pressRecognizer)

        bounds = CGRect(origin: bounds.origin, size: CGSize(width: buttonRadius * 2, height: buttonRadius * 2))

        radioCircle.clipsToBounds = true
        radioCircle.layer.borderWidth = borderWidth
        radioCircle.layer.borderColor = borderColor.CGColor

        indicatorView.clipsToBounds = true

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(WRadioButton.radioButtonSelected(_:)),
                                                         name: wRadioButtonSelected,
                                                         object: nil)
    }

    public func setupUI() {
        radioCircle.snp_remakeConstraints { make in
            make.height.equalTo(buttonRadius * 2)
            make.width.equalTo(buttonRadius * 2)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }

        indicatorView.snp_remakeConstraints { make in
            make.centerX.equalTo(radioCircle)
            make.centerY.equalTo(radioCircle)
            make.height.equalTo(indicatorRadius * 2)
            make.width.equalTo(indicatorRadius * 2)
        }

        indicatorView.hidden = !selected

        let startingBlock: (Void) -> Void = {
            if (self.selected) {
                self.indicatorView.alpha = 1.0
            } else {
                self.indicatorView.alpha = 0.0
            }
        }

        let finishedBlock: (Void) -> Void = {
            if (!self.selected) {
                self.indicatorView.hidden = true
            }
        }

        if (animatedFlag) {
            animatedFlag = false
            UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState],
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

        radioCircle.layer.cornerRadius = radioCircle.frame.size.height / 2
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width / 2
    }

    public func radioButtonSelected(notification: NSNotification) {
        let sende: WRadioButton? = notification.object as! WRadioButton?

        if groupID == sende?.groupID {
            if !(buttonID == sende?.buttonID) {
                setSelected(false, animated: true)
            }
        }
    }

    public func setSelected(selected: Bool, animated: Bool) {
        animatedFlag = animated
        self.selected = selected

        if selected {
            // Send selection notification with group id
            NSNotificationCenter.defaultCenter().postNotificationName(wRadioButtonSelected,
                                                                      object: self)
        }
    }

    public func buttonWasPressed(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            radioCircle.backgroundColor = highlightColor
            break
        case .Ended:
            radioCircle.backgroundColor = buttonColor
            setSelected(true, animated: true)
        default:
            break
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: buttonRadius * 2, height: buttonRadius * 2)
    }
}
