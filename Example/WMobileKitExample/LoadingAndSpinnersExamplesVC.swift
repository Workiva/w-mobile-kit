//
//  LoadingAndSpinnersExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class LoadingAndSpinnersExamplesVC: WSideMenuContentVC {
    var currentProgress: CGFloat = 0
    let progressSpinner1 = WSpinner(frame: CGRectZero, fillColor: .whiteColor())
    let progressSpinner2 = WSpinner(frame: CGRectZero, fillColor: .grayColor())
    let progressSpinner3 = WSpinner(frame: CGRectZero, fillColor: .orangeColor())

    public override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Indeterminate spinners.
        let indeterminateSpinner1 = WSpinner(frame: CGRectZero, fillColor: .clearColor())
        view.addSubview(indeterminateSpinner1)
        indeterminateSpinner1.snp_makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(85)
            make.height.equalTo(85)
        }
        indeterminateSpinner1.indeterminate = true

        let indeterminateSpinner2 = WSpinner(frame: CGRectZero, fillColor: .clearColor())
        view.addSubview(indeterminateSpinner2)
        indeterminateSpinner2.snp_makeConstraints { (make) in
            make.centerY.equalTo(indeterminateSpinner1)
            make.right.equalTo(indeterminateSpinner1.snp_left).offset(-12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        indeterminateSpinner2.indeterminate = true
        indeterminateSpinner2.backgroundLineColor = .grayColor()

        let indeterminateSpinner3 = WSpinner(frame: CGRectZero, fillColor: .clearColor())
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
        progressSpinner2.backgroundLineColor = .cyanColor()

        view.addSubview(progressSpinner3)
        progressSpinner3.snp_makeConstraints { (make) in
            make.centerY.equalTo(progressSpinner1)
            make.left.equalTo(progressSpinner1.snp_right).offset(12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        progressSpinner3.lineWidth = 2
        progressSpinner3.progressLineColor = .blackColor()

        // Re
        let resetProgressButton = UIButton()
        view.addSubview(resetProgressButton)
        resetProgressButton.setTitle("Reset Progress", forState: .Normal)
        resetProgressButton.setTitleColor(.whiteColor(), forState: .Normal)
        resetProgressButton.backgroundColor = .lightGrayColor()
        resetProgressButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp_bottom).offset(-12)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoadingAndSpinnersExamplesVC.resetProgress(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        resetProgressButton.addGestureRecognizer(tapRecognizer)

        startProgress()
    }

    public func updateProgress(timer: NSTimer) {
        currentProgress += 0.02
        progressSpinner1.progress = currentProgress
        progressSpinner2.progress = currentProgress
        progressSpinner3.progress = currentProgress

        if (currentProgress >= 1) {
            timer.invalidate()
        }
    }

    public func startProgress() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(LoadingAndSpinnersExamplesVC.updateProgress(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    public func resetProgress(sender: AnyObject?) {
        currentProgress = 0
    }
}