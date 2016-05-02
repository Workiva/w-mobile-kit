//
//  LoadingAndSpinnersExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class LoadingAndSpinnersExamplesVC: WSideMenuContentVC {
    var currentProgress: CGFloat = 0
    let progressSpinner1 = WSpinner(frame: CGRectZero)
    let progressSpinner2 = WSpinner(frame: CGRectZero)
    let progressSpinner3 = WSpinner(frame: CGRectZero)
    var loadingModal: WLoadingModal? = nil

    public override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Indeterminate spinners.
        let indeterminateSpinner1 = WSpinner(frame: CGRectZero)
        view.addSubview(indeterminateSpinner1)
        indeterminateSpinner1.snp_makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(85)
            make.height.equalTo(85)
        }
        indeterminateSpinner1.indeterminate = true

        let indeterminateSpinner2 = WSpinner(frame: CGRectZero)
        view.addSubview(indeterminateSpinner2)
        indeterminateSpinner2.snp_makeConstraints { (make) in
            make.centerY.equalTo(indeterminateSpinner1)
            make.right.equalTo(indeterminateSpinner1.snp_left).offset(-12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        indeterminateSpinner2.indeterminate = true
        indeterminateSpinner2.backgroundLineColor = .grayColor()
        indeterminateSpinner2.progressLineColor = .blueColor()

        let indeterminateSpinner3 = WSpinner(frame: CGRectZero)
        view.addSubview(indeterminateSpinner3)
        indeterminateSpinner3.snp_makeConstraints { (make) in
            make.centerY.equalTo(indeterminateSpinner1)
            make.left.equalTo(indeterminateSpinner1.snp_right).offset(12)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        indeterminateSpinner3.indeterminate = true
        indeterminateSpinner3.progressLineColor = .orangeColor()

        // MARK: Progress spinners.
        view.addSubview(progressSpinner1)
        progressSpinner1.snp_makeConstraints { (make) in
            make.top.equalTo(indeterminateSpinner1.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        progressSpinner1.progressLineColor = .grayColor()
        progressSpinner1.backgroundLineColor = .cyanColor()

        view.addSubview(progressSpinner2)
        progressSpinner2.snp_makeConstraints { (make) in
            make.centerY.equalTo(progressSpinner1)
            make.right.equalTo(progressSpinner1.snp_left).offset(-12)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        progressSpinner2.lineWidth = 6
        progressSpinner2.progressLineColor = .cyanColor()

        view.addSubview(progressSpinner3)
        progressSpinner3.snp_makeConstraints { (make) in
            make.centerY.equalTo(progressSpinner1)
            make.left.equalTo(progressSpinner1.snp_right).offset(12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        progressSpinner3.lineWidth = 2
        progressSpinner3.progressLineColor = .blackColor()

        // MARK: Intended styling.
        let indeterminateSpinner4 = WSpinner(frame: CGRectZero)
        indeterminateSpinner4.indeterminate = true
        view.addSubview(indeterminateSpinner4)
        indeterminateSpinner4.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(progressSpinner1.snp_bottom).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        // MARK: Loading Modal
        let loadingModalButton = UIButton()
        view.addSubview(loadingModalButton)
        loadingModalButton.setTitle("Loading Modal", forState: .Normal)
        loadingModalButton.setTitleColor(.whiteColor(), forState: .Normal)
        loadingModalButton.backgroundColor = .clearColor()
        loadingModalButton.layer.borderColor = UIColor.whiteColor().CGColor
        loadingModalButton.layer.cornerRadius = 5
        loadingModalButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(indeterminateSpinner4.snp_bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        let loadingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoadingAndSpinnersExamplesVC.displayLoadingModal(_:)))
        loadingTapRecognizer.numberOfTapsRequired = 1
        loadingModalButton.addGestureRecognizer(loadingTapRecognizer)

        // MARK: Reset progress to allow a better demo.
        let resetProgressButton = UIButton()
        view.addSubview(resetProgressButton)
        resetProgressButton.setTitle("Reset Progress", forState: .Normal)
        resetProgressButton.setTitleColor(.whiteColor(), forState: .Normal)
        resetProgressButton.backgroundColor = .clearColor()
        resetProgressButton.layer.borderColor = UIColor.whiteColor().CGColor
        resetProgressButton.layer.cornerRadius = 5
        resetProgressButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp_bottom).offset(-12)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        let resetTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoadingAndSpinnersExamplesVC.resetProgress(_:)))
        resetTapRecognizer.numberOfTapsRequired = 1
        resetProgressButton.addGestureRecognizer(resetTapRecognizer)

        startProgress()
    }

    public func updateProgress(timer: NSTimer) {
        currentProgress += 0.02
        setProgress(currentProgress)

        if (currentProgress >= 1) {
            timer.invalidate()
        }
    }

    public func setProgress(progress: CGFloat) {
        progressSpinner1.progress = progress
        progressSpinner2.progress = progress
        progressSpinner3.progress = progress

        if (loadingModal != nil) {
            loadingModal!.setProgress(progress)
        }
    }

    public func startProgress() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(LoadingAndSpinnersExamplesVC.updateProgress(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    public func resetProgress(sender: AnyObject?) {
        currentProgress = 0
        setProgress(currentProgress)
        startProgress()

        view.setNeedsDisplay()
    }

    public func displayLoadingModal(sender: AnyObject?) {
        loadingModal = WLoadingModal(.grayColor(),
                                     title: "Title Text",
                                     description: "And a short description for this loading modal. This will go away in 5 seconds.")

        loadingModal?.descriptionLabelHeight = 100

        loadingModal?.show(self.view, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(LoadingAndSpinnersExamplesVC.dismissLoadingModal(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    public func dismissLoadingModal(sender: AnyObject?) {
        if (loadingModal != nil) {
            loadingModal!.removeFromSuperview()

            if let timer = sender as? NSTimer {
                timer.invalidate()
            }
        }
    }
}